variable "name" {
  description = "Name of the App Configuration store"
  type        = string
}

variable "location" {
  description = "Azure region where the App Configuration will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "sku" {
  description = "SKU of the App Configuration (free or standard)"
  type        = string
  default     = "free"
  validation {
    condition     = contains(["free", "standard"], var.sku)
    error_message = "SKU must be either 'free' or 'standard'."
  }
}

variable "feature_flags" {
  description = "Map of feature flags to create"
  type = map(object({
    label       = optional(string)
    enabled     = bool
    description = optional(string)
  }))
  default = {}
}

variable "configuration_keys" {
  description = "Map of configuration key-value pairs to create"
  type = map(object({
    value        = string
    label        = optional(string)
    content_type = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to the App Configuration"
  type        = map(string)
  default     = {}
}
