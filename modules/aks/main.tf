terraform {
  required_version = ">= 1.13.4"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.51.0"
    }
  }
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name                 = var.default_node_pool_name
    node_count           = var.enable_auto_scaling ? null : var.node_count
    vm_size              = var.vm_size
    os_disk_size_gb      = var.os_disk_size_gb
    vnet_subnet_id       = var.subnet_id
    auto_scaling_enabled = var.enable_auto_scaling
    min_count            = var.enable_auto_scaling ? var.min_count : null
    max_count            = var.enable_auto_scaling ? var.max_count : null
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = var.network_plugin
    network_policy    = var.network_policy
    load_balancer_sku = "standard"
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
  }

  # Habilitar Azure Monitor para contenedores (opcional)
  dynamic "oms_agent" {
    for_each = var.log_analytics_workspace_id != null ? [1] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  # Habilitar Azure Key Vault Secrets Provider
  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  tags = var.tags
}

# Asignación de rol para ACR pull
resource "azurerm_role_assignment" "aks_acr" {
  count                = var.acr_id != null ? 1 : 0
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = var.acr_id
}
