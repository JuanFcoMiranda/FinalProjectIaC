variable "name" {
  description = "The name of the Storage Account."
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

variable "container_name" {
  description = "The name of the container."
  default     = "tfstate"
  type        = string
}
