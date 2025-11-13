output "id" {
  description = "ID of the App Configuration"
  value       = azurerm_app_configuration.this.id
}

output "name" {
  description = "Name of the App Configuration"
  value       = azurerm_app_configuration.this.name
}

output "endpoint" {
  description = "Endpoint URL of the App Configuration"
  value       = azurerm_app_configuration.this.endpoint
}

output "identity_principal_id" {
  description = "Principal ID of the system assigned identity"
  value       = azurerm_app_configuration.this.identity[0].principal_id
}

output "primary_read_key" {
  description = "Primary read key for the App Configuration"
  value       = azurerm_app_configuration.this.primary_read_key
  sensitive   = true
}

output "secondary_read_key" {
  description = "Secondary read key for the App Configuration"
  value       = azurerm_app_configuration.this.secondary_read_key
  sensitive   = true
}
