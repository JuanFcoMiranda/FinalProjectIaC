# BACKEND GENERICO - reemplaza los valores entre <> antes de ejecutar `terraform init`
terraform {
  backend "azurerm" {
    resource_group_name  = "<REPLACE_RESOURCE_GROUP_NAME>"
    storage_account_name = "<REPLACE_STORAGE_ACCOUNT_NAME>"
    container_name       = "<REPLACE_CONTAINER_NAME>"
    key                  = "<REPLACE_KEY.tfstate>"
  }
}
