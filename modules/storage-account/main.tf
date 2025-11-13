terraform {
  required_version = ">= 1.13.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.51.0"
    }
  }
}

resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "this" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}
