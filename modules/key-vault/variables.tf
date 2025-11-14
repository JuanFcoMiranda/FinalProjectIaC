variable "name" {
  description = "Name of the Key Vault (must be globally unique, 3-24 chars)"
  type        = string
  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 24
    error_message = "Key Vault name must be between 3 and 24 characters."
  }
}

variable "location" {
  description = "Azure region where the Key Vault will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "sku_name" {
  description = "SKU name for the Key Vault (standard or premium)"
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "premium"], var.sku_name)
    error_message = "SKU name must be either 'standard' or 'premium'."
  }
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain deleted Key Vault items"
  type        = number
  default     = 7
  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "Soft delete retention days must be between 7 and 90."
  }
}

variable "purge_protection_enabled" {
  description = "Enable purge protection for the Key Vault"
  type        = bool
  default     = false
}

variable "rbac_authorization_enabled" {
  description = "Enable RBAC authorization for the Key Vault instead of access policies"
  type        = bool
  default     = false
}

variable "default_action" {
  description = "Default action for network rules (Allow or Deny)"
  type        = string
  default     = "Deny"
  validation {
    condition     = contains(["Allow", "Deny"], var.default_action)
    error_message = "Default action must be either 'Allow' or 'Deny'."
  }
}

variable "bypass" {
  description = "Traffic to bypass network rules (AzureServices or None)"
  type        = string
  default     = "AzureServices"
  validation {
    condition     = contains(["AzureServices", "None"], var.bypass)
    error_message = "Bypass must be either 'AzureServices' or 'None'."
  }
}

variable "ip_rules" {
  description = "List of IP addresses or CIDR blocks to allow access"
  type        = list(string)
  default     = []
}

variable "aks_identity_object_id" {
  description = "Object ID of the AKS identity for access policy"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the Key Vault"
  type        = map(string)
  default     = {}
}
