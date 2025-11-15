variable "resource_group_name" {
  default = "rg-juanfran-demo"
  type    = string
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"
}

variable "acr_name" {
  default = "acrjuanfrandemo"
  type    = string
}

variable "tfstate_storage_name" {
  default = "tfstatejuanfran"
  type    = string
}

variable "location" {
  default = "spaincentral"
  type    = string
}

variable "aks_cluster_name" {
  default     = "aks-juanfran-demo"
  type        = string
  description = "Name of the AKS cluster"
}

variable "aks_dns_prefix" {
  default     = "aks-juanfran"
  type        = string
  description = "DNS prefix for the AKS cluster"
}

variable "key_vault_name" {
  default     = "kv-juanfran-demo"
  type        = string
  description = "Name of the Key Vault (must be globally unique, 3-24 chars)"
}

variable "app_config_name" {
  default     = "appconfig-juanfran"
  type        = string
  description = "Name of the App Configuration store"
}
