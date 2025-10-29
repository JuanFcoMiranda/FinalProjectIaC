output "resource_group_name" {
  value = module.rg.name
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "tfstate_storage_name" {
  value = module.tfstate_storage.name
}
