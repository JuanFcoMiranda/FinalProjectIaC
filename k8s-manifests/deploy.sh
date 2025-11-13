# Script para desplegar Prometheus y Grafana en AKS

# Conectarse al cluster de AKS
# Ejecutar: az aks get-credentials --resource-group <rg-name> --name <aks-name>

# 1. Crear el namespace de monitoring
kubectl apply -f namespace.yaml

# 2. Desplegar Prometheus
kubectl apply -f prometheus-configmap.yaml
kubectl apply -f prometheus-serviceaccount.yaml
kubectl apply -f prometheus-clusterrole.yaml
kubectl apply -f prometheus-clusterrolebinding.yaml
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f prometheus-service.yaml

# 3. Desplegar Grafana
kubectl apply -f grafana.yaml

# 4. Verificar los pods
kubectl get pods -n monitoring

# 5. Obtener la IP externa de Grafana (puede tardar unos minutos)
kubectl get service grafana -n monitoring

# Credenciales de Grafana por defecto:
# Usuario: admin
# Password: admin (se debe cambiar en el primer login)

# Para acceder a Prometheus localmente:
# kubectl port-forward -n monitoring svc/prometheus 9090:9090

# Para acceder a Grafana localmente si no tienes LoadBalancer:
# kubectl port-forward -n monitoring svc/grafana 3000:3000
