output "login_server" {
  description = "The login server of the container registry"
  value = azurerm_container_registry.this.login_server
}
