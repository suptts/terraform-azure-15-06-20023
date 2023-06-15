# This is /0-ResourceGroup/rg.tf
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

# Create a resource group - RG-TF-VM-Identity
resource "azurerm_resource_group" "Identity" {
  name     = "RG-TF-VM-Identity"
  location = "southeastasia"
  tags = {
    environment = "Production"
    CreatedBy   = "Suparuek P"
    ProjectName = "TF"
  }
}
# Create a resource group - RG-TF-VM-Database
resource "azurerm_resource_group" "Database" {
  name     = "RG-TF-VM-Database"
  location = "southeastasia"
  tags = {
    environment = "Production"
    CreatedBy   = "Suparuek P"
    ProjectName = "TF"
  }
}
# Create a resource group - RG-TF-VM-Network
resource "azurerm_resource_group" "Network" {
  name     = "RG-TF-VM-Network"
  location = "southeastasia"
  tags = {
    environment = "Production"
    CreatedBy   = "Suparuek P"
    ProjectName = "TF"
  }
}
# Create a resource group - RG-TF-VM-WebFrontEnd
resource "azurerm_resource_group" "WebFronEnd" {
  name     = "RG-TF-VM-WebFronEnd"
  location = "southeastasia"
  tags = {
    environment = "Production"
    CreatedBy   = "Suparuek P"
    ProjectName = "TF"
  }
}
# Create a resource group - RG-TF-VM-Storage
resource "azurerm_resource_group" "Storage" {
  name     = "RG-TF-SA-Storage"
  location = "southeastasia"
  tags = {
    environment = "Production"
    CreatedBy   = "Suparuek P"
    ProjectName = "TF"
  }
}


# Create a resource group - RG-TF-VM-NSG
resource "azurerm_resource_group" "NSG" {
  name     = "RG-TF-VM-NSG"
  location = "southeastasia"
  tags = {
    environment = "Production"
    CreatedBy   = "Suparuek P"
    ProjectName = "TF"
  }
}
