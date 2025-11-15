output "id" {
  description = "The ID of the container registry"
  value       = azurerm_container_registry.acr.id
}

output "login_server" {
  description = "The login server of the container registry"
  value       = azurerm_container_registry.acr.login_server
}
