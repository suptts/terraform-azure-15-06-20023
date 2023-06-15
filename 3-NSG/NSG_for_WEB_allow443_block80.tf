# This is /3-NSG/NSG_for_Web_allow443_block80.tf
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
data "azurerm_resource_group" "ExistingNGSRG" {
  name = "RG-TF-VM-NSG"
}


resource "azurerm_network_security_group" "nsg" {
  name                = "NSG-TF-WEB-Linux-Allow443-Block80"
  location            = data.azurerm_resource_group.ExistingNGSRG.location
  resource_group_name = data.azurerm_resource_group.ExistingNGSRG.name
}
resource "azurerm_network_security_rule" "example1" {
  name                        = "Web443Allow"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "443"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.ExistingNGSRG.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "example2" {
  name                        = "Web80Deny"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "80"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.ExistingNGSRG.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "example3" {
  name                        = "SSH"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.ExistingNGSRG.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
resource "azurerm_network_security_rule" "example4" {
  name                        = "Web80OutDeny"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "80"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.ExistingNGSRG.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
