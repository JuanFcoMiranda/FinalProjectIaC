output "resource_group_name" {
  value = module.rg.name
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "tfstate_storage_name" {
  value = module.tfstate_storage.name
}

# AKS outputs
output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = module.aks.name
}

output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = module.aks.id
}

output "aks_kube_config" {
  description = "Kubernetes configuration for the AKS cluster"
  value       = module.aks.kube_config
  sensitive   = true
}

# Key Vault outputs
output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.key_vault.vault_uri
}

# App Configuration outputs
output "app_config_name" {
  description = "Name of the App Configuration store"
  value       = module.app_config.name
}

output "app_config_endpoint" {
  description = "Endpoint URL of the App Configuration"
  value       = module.app_config.endpoint
}
