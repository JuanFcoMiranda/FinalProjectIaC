terraform {
  required_version = ">= 1.13.4"

  backend "azurerm" {
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.51.0"
    }
  }
}

module "rg" {
  source   = "./modules/resource-group"
  name     = var.resource_group_name
  location = var.location
}

module "tfstate_storage" {
  source              = "./modules/storage-account"
  name                = var.tfstate_storage_name
  resource_group_name = module.rg.name
  location            = module.rg.location
  container_name      = "tfstate"
}

module "acr" {
  source              = "./modules/acr"
  name                = var.acr_name
  resource_group_name = module.rg.name
  location            = module.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Key Vault para secretos y contraseñas
module "key_vault" {
  source              = "./modules/key-vault"
  name                = var.key_vault_name
  resource_group_name = module.rg.name
  location            = module.rg.location
  sku_name            = "standard"

  # Permitir acceso desde AKS
  aks_identity_object_id = module.aks.key_vault_secrets_provider_identity

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
  }

  depends_on = [module.aks]
}

# App Configuration para feature flags
module "app_config" {
  source              = "./modules/app-configuration"
  name                = var.app_config_name
  resource_group_name = module.rg.name
  location            = module.rg.location
  sku                 = "free"

  # Feature flags de ejemplo
  feature_flags = {
    "beta_features" = {
      enabled     = false
      description = "Enable beta features in the application"
    }
    "dark_mode" = {
      enabled     = true
      description = "Enable dark mode UI"
    }
  }

  # Configuraciones de ejemplo
  configuration_keys = {
    "app_settings:max_connections" = {
      value = "100"
    }
    "app_settings:timeout" = {
      value = "30"
    }
  }

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
  }
}

# AKS Cluster con Prometheus y Grafana
module "aks" {
  source              = "./modules/aks"
  name                = var.aks_cluster_name
  resource_group_name = module.rg.name
  location            = module.rg.location
  dns_prefix          = var.aks_dns_prefix

  kubernetes_version = "1.28"
  node_count         = 2
  vm_size            = "Standard_D2s_v3"

  enable_auto_scaling = true
  min_count           = 2
  max_count           = 5

  # Integración con ACR
  acr_id = module.acr.id

  tags = {
    Environment = "Demo"
    ManagedBy   = "Terraform"
  }
}
