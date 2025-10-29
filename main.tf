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
