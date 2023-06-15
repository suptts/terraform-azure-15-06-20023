# This is /1-StorageAccount/v1/sa_v1.tf
# Last Modified: 15 June 2023


# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used


# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }


  required_version = ">= 1.1.0"
}


provider "azurerm" {
  features {}
}


# refer to a resource group
data "azurerm_resource_group" "ExistingStorageRG" {
  name = "RG-TF-SA-Storage"
}


resource "azurerm_storage_account" "ExistingStorageRG" {
  name                = "sa4productionv1ploy"
  resource_group_name = data.azurerm_resource_group.ExistingStorageRG.name
  location            = data.azurerm_resource_group.ExistingStorageRG.location
  #account_kind = "Storage2"
  account_kind             = "Storage"
  account_tier             = "Standard"
  account_replication_type = "LRS"


  tags = {
    environment = "Terraform Storage"
    CreatedBy   = "Suparuek P"
  }
}


resource "azurerm_storage_container" "ExistingStorageRG" {
  name                 = "blobcontainer4tf"
  storage_account_name = azurerm_storage_account.ExistingStorageRG.name
  #storage_account_name =
  container_access_type = "private"
}


resource "azurerm_storage_blob" "ExistingStorageRG" {
  name                   = "terraformblob"
  storage_account_name   = azurerm_storage_account.ExistingStorageRG.name
  storage_container_name = azurerm_storage_container.ExistingStorageRG.name
  type                   = "Block"
}
resource "azurerm_storage_share" "ExistingStorageRG" {
  name                 = "terraformshare"
  storage_account_name = azurerm_storage_account.ExistingStorageRG.name
  quota                = 50
}
