terraform {
  required_version = ">= 1.13.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.51.0"
    }
  }
}

resource "azurerm_app_configuration" "app_config" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Crear feature flags de ejemplo
resource "azurerm_app_configuration_feature" "feature_flags" {
  for_each               = var.feature_flags
  configuration_store_id = azurerm_app_configuration.app_config.id
  name                   = each.key
  label                  = each.value.label
  enabled                = each.value.enabled
  description            = each.value.description
}

# Crear key-values de configuración
resource "azurerm_app_configuration_key" "config_keys" {
  for_each               = var.configuration_keys
  configuration_store_id = azurerm_app_configuration.app_config.id
  key                    = each.key
  value                  = each.value.value
  label                  = each.value.label
  content_type           = each.value.content_type
}
