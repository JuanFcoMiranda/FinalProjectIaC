#!/bin/bash
# Script de bootstrap para crear Storage Account para Terraform backend
set -euo pipefail

RG="tfstate-rg"
LOCATION="Spain Central"
STORAGE="tfstatejuanfran"
CONTAINER="tfstate"

echo "Creando Resource Group..."
az group create --name "$RG" --location "$LOCATION"

echo "Creando Storage Account..."
az storage account create --name "$STORAGE" --resource-group "$RG" --location "$LOCATION" --sku Standard_LRS

echo "Creando contenedor para estado de Terraform..."
az storage container create --name "$CONTAINER" --account-name "$STORAGE"

echo "¡Bootstrap completado!"
