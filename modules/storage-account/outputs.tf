output "name" {
  description = "The name of the storage account"
  value = azurerm_storage_account.this.name
}

output "container_name" {
  description = "The name of the storage container"
  value = azurerm_storage_container.this.name
}

output "primary_access_key" {
  description = "The primary access key of the storage account"
  value     = azurerm_storage_account.this.primary_access_key
  sensitive = true
}
