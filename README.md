# Proyecto de Infraestructura con Terraform en Azure

Este proyecto despliega una infraestructura completa en Azure usando Terraform, incluyendo:

## Recursos Desplegados

### 1. Resource Group
- Grupo de recursos principal para organizar todos los componentes

### 2. Storage Account
- Cuenta de almacenamiento para el backend de Terraform (tfstate)
- Container de blobs para almacenar el estado

### 3. Azure Container Registry (ACR)
- Registro privado de contenedores Docker
- Integrado con AKS para pull automático de imágenes

### 4. Azure Kubernetes Service (AKS)
- Cluster de Kubernetes gestionado
- Auto-scaling habilitado (2-5 nodos)
- Integración con ACR
- Key Vault Secrets Provider habilitado
- VM Size: Standard_D2s_v3

### 5. Azure Key Vault
- Almacenamiento seguro de secretos, claves y certificados
- Integrado con AKS mediante CSI Driver
- Políticas de acceso configuradas

### 6. Azure App Configuration
- Gestión centralizada de configuración de aplicaciones
- Feature flags para desarrollo ágil
- Ejemplos incluidos:
  - `beta_features`: Control de características beta
  - `dark_mode`: Modo oscuro de la interfaz

### 7. Monitorización con Prometheus y Grafana
- Prometheus para recolección de métricas
- Grafana para visualización de datos
- Manifiestos de Kubernetes listos para desplegar

## Estructura del Proyecto

```
.
├── main.tf                    # Configuración principal
├── variables.tf               # Variables de entrada
├── outputs.tf                 # Outputs del proyecto
├── backend.tf                 # Configuración del backend
├── providers.tf               # Configuración de providers
├── versions.tf                # Versiones de Terraform y providers
├── modules/
│   ├── resource-group/        # Módulo de Resource Group
│   ├── storage-account/       # Módulo de Storage Account
│   ├── acr/                   # Módulo de Container Registry
│   ├── aks/                   # Módulo de AKS
│   ├── key-vault/             # Módulo de Key Vault
│   └── app-configuration/     # Módulo de App Configuration
└── k8s-manifests/             # Manifiestos de Kubernetes
    ├── namespace.yaml         # Namespace de monitoring
    ├── prometheus.yaml        # Deployment de Prometheus
    ├── grafana.yaml          # Deployment de Grafana
    └── deploy.sh             # Script de despliegue
```

## Requisitos Previos

- Terraform >= 1.13.4
- Azure CLI
- kubectl
- Cuenta de Azure con permisos suficientes

## Uso

### 1. Inicializar Terraform

```bash
terraform init \
  -backend-config="resource_group_name=<tu-rg>" \
  -backend-config="storage_account_name=<tu-storage>" \
  -backend-config="container_name=<tu-container>" \
  -backend-config="key=terraform.tfstate"
```

### 2. Personalizar Variables

Edita `variables.tf` o crea un archivo `terraform.tfvars`:

```hcl
resource_group_name = "rg-mi-proyecto"
location           = "spaincentral"
aks_cluster_name   = "aks-mi-cluster"
key_vault_name     = "kv-mi-proyecto"
app_config_name    = "appconfig-mi-app"
```

### 3. Planificar el Despliegue

```bash
terraform plan
```

### 4. Aplicar la Configuración

```bash
terraform apply
```

### 5. Desplegar Prometheus y Grafana

Una vez desplegado AKS:

```bash
# Obtener credenciales de AKS
az aks get-credentials --resource-group <rg-name> --name <aks-name>

# Desplegar monitoring
cd k8s-manifests
chmod +x deploy.sh
./deploy.sh

# Verificar despliegue
kubectl get pods -n monitoring
kubectl get svc -n monitoring
```

## Acceso a Grafana

Grafana se despliega con un servicio LoadBalancer:

```bash
# Obtener la IP externa
kubectl get service grafana -n monitoring

# Credenciales por defecto:
# Usuario: admin
# Password: admin (cambiar en el primer login)
```

Para acceso local con port-forward:

```bash
kubectl port-forward -n monitoring svc/grafana 3000:3000
# Acceder en: http://localhost:3000
```

## Acceso a Prometheus

```bash
kubectl port-forward -n monitoring svc/prometheus 9090:9090
# Acceder en: http://localhost:9090
```

## Integración con Key Vault en AKS

El cluster AKS tiene habilitado el Key Vault Secrets Provider. Para usar secretos:

1. Crear secretos en Key Vault
2. Crear un SecretProviderClass en Kubernetes
3. Montar como volumen en tus pods

Ejemplo de SecretProviderClass:

```yaml
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: azure-kv-secrets
spec:
  provider: azure
  parameters:
    usePodIdentity: "false"
    useVMManagedIdentity: "true"
    userAssignedIdentityID: <identity-client-id>
    keyvaultName: <key-vault-name>
    objects: |
      array:
        - |
          objectName: secret-name
          objectType: secret
    tenantId: <tenant-id>
```

## App Configuration - Feature Flags

Para consultar los feature flags desde tu aplicación:

```bash
# Obtener la connection string
az appconfig credential list \
  --name <app-config-name> \
  --resource-group <rg-name>
```

## Outputs Disponibles

- `resource_group_name`: Nombre del resource group
- `acr_login_server`: Servidor de login del ACR
- `aks_cluster_name`: Nombre del cluster AKS
- `aks_kube_config`: Configuración de kubectl (sensible)
- `key_vault_name`: Nombre del Key Vault
- `key_vault_uri`: URI del Key Vault
- `app_config_name`: Nombre de App Configuration
- `app_config_endpoint`: Endpoint de App Configuration

## Limpieza

Para eliminar todos los recursos:

```bash
terraform destroy
```

## CI/CD con GitHub Actions

El proyecto incluye workflows de GitHub Actions para:
- Terraform Plan en push a main
- Validación de formato y sintaxis
- Gestión automática del backend de Terraform

## Notas Importantes

1. **Key Vault Name**: Debe ser único globalmente (3-24 caracteres)
2. **App Config Name**: Debe ser único globalmente
3. **ACR Name**: Debe ser único globalmente
4. **Costos**: Revisa los costos asociados con AKS, Key Vault Premium, etc.
5. **Seguridad**: Cambia las contraseñas por defecto de Grafana
6. **Red**: Los manifiestos de Kubernetes usan configuración básica, personaliza según tus necesidades de red

## Mejoras Futuras

- [ ] Implementar backup automático del Key Vault
- [ ] Configurar alertas en Grafana
- [ ] Añadir dashboards personalizados
- [ ] Implementar políticas de red en AKS
- [ ] Configurar Azure Monitor Integration
- [ ] Implementar GitOps con Flux o ArgoCD

## Autor

Juanfran
