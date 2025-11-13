# Guía de Despliegue - Pipeline CI/CD

Este documento explica el flujo de despliegue automatizado de la infraestructura y el stack de monitorización.

## Workflow: Terraform Plan and Apply

El workflow principal se ejecuta automáticamente al hacer push a la rama `main`.

### Jobs del Pipeline

#### 1. **Plan** 
Analiza los cambios de infraestructura sin aplicarlos.

**Pasos:**
- ✓ Checkout del código
- ✓ Configuración de Terraform
- ✓ Login en Azure con OIDC
- ✓ Verificación/creación del backend de Terraform (Resource Group, Storage Account, Container)
- ✓ Inicialización de Terraform
- ✓ Validación de formato y sintaxis
- ✓ Generación del plan de ejecución
- ✓ Upload del plan como artefacto

#### 2. **Apply**
Aplica los cambios de infraestructura planificados.

**Pasos:**
- ✓ Checkout del código
- ✓ Configuración de Terraform
- ✓ Login en Azure
- ✓ Descarga del plan generado
- ✓ Inicialización de Terraform
- ✓ Aplicación del plan
- ✓ Extracción de outputs (nombre de AKS y Resource Group)
- ✓ Upload de outputs para el siguiente job

**Recursos desplegados:**
- Resource Group
- Storage Account (para tfstate)
- Azure Container Registry (ACR)
- Azure Kubernetes Service (AKS)
- Azure Key Vault
- Azure App Configuration

#### 3. **Deploy Monitoring**
Despliega el stack de monitorización en el cluster de AKS.

**Pasos:**
- ✓ Checkout del código
- ✓ Login en Azure
- ✓ Configuración de Terraform (sin wrapper para outputs limpios)
- ✓ Descarga del estado de Terraform
- ✓ Obtención de credenciales de AKS
- ✓ Verificación de conexión con kubectl
- ✓ Despliegue del namespace `monitoring`
- ✓ Despliegue de Prometheus
- ✓ Despliegue de Grafana
- ✓ Espera hasta que los deployments estén listos
- ✓ Obtención del estado de los servicios
- ✓ Generación de resumen en GitHub

**Componentes desplegados:**
- Namespace: `monitoring`
- Prometheus (ClusterIP service)
- Grafana (LoadBalancer service)
- ServiceAccounts y RBAC necesarios

## Configuración de Secretos de GitHub

Necesitas configurar los siguientes secretos en tu repositorio:

```
AZURE_CLIENT_ID         # Client ID de la aplicación de Azure AD
AZURE_TENANT_ID         # Tenant ID de Azure
AZURE_SUBSCRIPTION_ID   # Subscription ID de Azure
RESOURCE_GROUP          # Nombre del resource group para el backend
RESOURCE_LOCATION       # Región de Azure (ej: spaincentral)
STORAGE_ACCOUNT         # Nombre de la storage account para tfstate
CONTAINER_NAME          # Nombre del container de blobs
SUBSCRIPTION_ID         # ID de la suscripción (puede ser igual a AZURE_SUBSCRIPTION_ID)
```

### Configuración de OIDC

Este pipeline usa autenticación OIDC (OpenID Connect) para Azure, lo que elimina la necesidad de almacenar credenciales secretas.

**Pasos para configurar OIDC:**

1. Crear una aplicación en Azure AD
2. Configurar federated credentials para GitHub Actions
3. Asignar roles necesarios a la aplicación (Contributor, etc.)
4. Configurar los secretos en GitHub

[Guía oficial de Microsoft](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure)

## Acceso a los Servicios Desplegados

### Grafana

Grafana se despliega con un LoadBalancer service que obtiene una IP pública.

**Obtener la IP externa:**
```bash
kubectl get svc grafana -n monitoring
```

**Credenciales por defecto:**
- Usuario: `admin`
- Password: `admin` (cambiar en el primer login)

**Acceso vía port-forward (alternativa):**
```bash
kubectl port-forward -n monitoring svc/grafana 3000:3000
# Acceder en: http://localhost:3000
```

### Prometheus

Prometheus se despliega con un ClusterIP service (interno).

**Acceso vía port-forward:**
```bash
kubectl port-forward -n monitoring svc/prometheus 9090:9090
# Acceder en: http://localhost:9090
```

## Verificación del Despliegue

### Verificar recursos de Azure:
```bash
# Listar recursos en el resource group
az resource list --resource-group <rg-name> --output table

# Verificar el cluster de AKS
az aks show --resource-group <rg-name> --name <aks-name>

# Verificar Key Vault
az keyvault show --name <kv-name>

# Verificar App Configuration
az appconfig show --name <app-config-name>
```

### Verificar despliegue de Kubernetes:
```bash
# Obtener credenciales de AKS
az aks get-credentials --resource-group <rg-name> --name <aks-name>

# Verificar nodos
kubectl get nodes

# Verificar pods de monitoring
kubectl get pods -n monitoring

# Verificar servicios
kubectl get svc -n monitoring

# Ver logs de Prometheus
kubectl logs -n monitoring deployment/prometheus -f

# Ver logs de Grafana
kubectl logs -n monitoring deployment/grafana -f
```

## Troubleshooting

### El job de Apply falla

1. Verifica que todos los secretos estén configurados correctamente
2. Revisa los logs del job en GitHub Actions
3. Verifica los permisos de la aplicación de Azure AD

### Grafana no obtiene IP externa

En algunos casos, el LoadBalancer puede tardar varios minutos:
```bash
kubectl get svc grafana -n monitoring --watch
```

Si no se asigna IP después de 10 minutos, verifica:
- Cuota de IPs públicas en Azure
- Políticas de red del cluster
- Estado del servicio: `kubectl describe svc grafana -n monitoring`

### Prometheus no recolecta métricas

1. Verificar configuración:
```bash
kubectl get configmap prometheus-config -n monitoring -o yaml
```

2. Verificar logs:
```bash
kubectl logs -n monitoring deployment/prometheus
```

3. Verificar RBAC:
```bash
kubectl get clusterrole prometheus
kubectl get clusterrolebinding prometheus
```

### Conexión a AKS falla en la pipeline

Verifica que:
- El cluster de AKS se haya desplegado correctamente
- La identidad de la aplicación tenga permisos suficientes
- Los outputs de Terraform sean correctos

## Rollback

Si necesitas revertir cambios:

### Rollback de Kubernetes:
```bash
# Eliminar stack de monitoring
kubectl delete -f k8s-manifests/grafana.yaml
kubectl delete -f k8s-manifests/prometheus.yaml
kubectl delete -f k8s-manifests/namespace.yaml
```

### Rollback de infraestructura:
```bash
# Localmente
terraform destroy

# O desde la pipeline, modifica el workflow para ejecutar destroy
```

## Mejoras Futuras

- [ ] Añadir approval manual antes del Apply
- [ ] Implementar ambientes (dev, staging, prod)
- [ ] Añadir tests de integración post-deployment
- [ ] Configurar notificaciones en Slack/Teams
- [ ] Implementar drift detection automático
- [ ] Añadir backup automático del estado de Terraform
- [ ] Configurar alertas en Prometheus
- [ ] Añadir dashboards personalizados en Grafana
- [ ] Implementar políticas de seguridad con Azure Policy
- [ ] Añadir escaneo de vulnerabilidades de imágenes

## Recursos Adicionales

- [Documentación de Terraform para Azure](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GitHub Actions para Azure](https://github.com/Azure/actions)
- [Prometheus Kubernetes Operator](https://github.com/prometheus-operator/prometheus-operator)
- [Grafana Dashboards](https://grafana.com/grafana/dashboards/)
