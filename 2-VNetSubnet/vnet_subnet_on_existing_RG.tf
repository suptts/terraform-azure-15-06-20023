# This is /3-VNetSubnet/vnet_subnet_on_exiting_RG.tf
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
data "azurerm_resource_group" "ExistingNetworkRG" {
  name = "RG-TF-VM-Network"
}


# Create virtual network - VNet
resource "azurerm_virtual_network" "TFNet" {
  name                = "TFVNet5Subnets"
  address_space       = ["10.1.0.0/16"]
  resource_group_name = data.azurerm_resource_group.ExistingNetworkRG.name
  location            = data.azurerm_resource_group.ExistingNetworkRG.location
}
# Create virtual network - internal Subnet1
resource "azurerm_subnet" "tfsubnet1" {
  name                 = "subnet1-internal-dmz"
  resource_group_name  = data.azurerm_resource_group.ExistingNetworkRG.name
  virtual_network_name = azurerm_virtual_network.TFNet.name
  address_prefixes     = ["10.1.1.0/24"]
}
# Create virtual network - internal Subnet2
resource "azurerm_subnet" "tfsubnet2" {
  name                 = "subnet2-internal-frontend"
  resource_group_name  = data.azurerm_resource_group.ExistingNetworkRG.name
  virtual_network_name = azurerm_virtual_network.TFNet.name
  address_prefixes     = ["10.1.2.0/24"]
}
# Create virtual network - DMZ Subnet3
resource "azurerm_subnet" "tfsubnet3" {
  name                 = "subnet3-internal-backend"
  resource_group_name  = data.azurerm_resource_group.ExistingNetworkRG.name
  virtual_network_name = azurerm_virtual_network.TFNet.name
  address_prefixes     = ["10.1.3.0/24"]
}


# Create virtual network - internal Subnet4
resource "azurerm_subnet" "tfsubnet4" {
  name                 = "subnet4-internal-backend"
  resource_group_name  = data.azurerm_resource_group.ExistingNetworkRG.name
  virtual_network_name = azurerm_virtual_network.TFNet.name
  address_prefixes     = ["10.1.4.0/24"]
}


# Create virtual network - internal Subnet5
resource "azurerm_subnet" "tfsubnet5" {
  name                 = "subnet5-internal-backend"
  resource_group_name  = data.azurerm_resource_group.ExistingNetworkRG.name
  virtual_network_name = azurerm_virtual_network.TFNet.name
  address_prefixes     = ["10.1.5.0/24"]
}
