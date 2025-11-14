output "id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.key_vault.id
}

output "name" {
  description = "Name of the Key Vault"
  value       = azurerm_key_vault.key_vault.name
}

output "vault_uri" {
  description = "URI of the Key Vault"
  value       = azurerm_key_vault.key_vault.vault_uri
}

output "tenant_id" {
  description = "Tenant ID of the Key Vault"
  value       = azurerm_key_vault.key_vault.tenant_id
}
