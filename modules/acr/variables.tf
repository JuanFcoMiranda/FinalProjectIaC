variable "name" {
  description = "The name of the Azure Container Registry."
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The location where the resources will be created."
  type        = string
}

variable "sku" {
  description = "The SKU of the Azure Container Registry."
  default     = "Basic"
  type        = string
}

variable "admin_enabled" {
  description = "Enable admin user."
  default     = false
  type        = bool
}
