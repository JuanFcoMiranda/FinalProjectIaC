output "id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.id
}

output "name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.name
}

output "kube_config" {
  description = "Kubernetes configuration"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "host" {
  description = "Kubernetes API server host"
  value       = azurerm_kubernetes_cluster.this.kube_config[0].host
}

output "cluster_ca_certificate" {
  description = "Cluster CA certificate"
  value       = azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
  sensitive   = true
}

output "identity_principal_id" {
  description = "Principal ID of the system assigned identity"
  value       = azurerm_kubernetes_cluster.this.identity[0].principal_id
}

output "kubelet_identity_object_id" {
  description = "Object ID of the kubelet identity"
  value       = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}

output "key_vault_secrets_provider_identity" {
  description = "Identity of the Key Vault Secrets Provider"
  value       = azurerm_kubernetes_cluster.this.key_vault_secrets_provider[0].secret_identity[0].object_id
}
