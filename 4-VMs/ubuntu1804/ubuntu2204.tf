# This is /4-VM/ubuntu2204.tf
# Last Modified: 11 October 2023
# Configure the Azure Provider and install.sh to install Docker


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
data "azurerm_resource_group" "ExistingVMRG" {
  name = "RG-TF-VM-Identity"
}
# refer to a resource group
data "azurerm_resource_group" "ExistingNetworkRG" {
  name = "RG-TF-VM-Network"
}
#refer to a subnet
data "azurerm_subnet" "ExistingNetworkRG" {
  name                 = "subnet1-internal-dmz"
  virtual_network_name = "TFVNet5Subnets"
  resource_group_name  = "RG-TF-VM-Network"
}
# Create public IPs
resource "azurerm_public_ip" "ExistingNetworkRG" {
  name                = "supdevopstts-RG-TF-VM-Network"
  location            = data.azurerm_resource_group.ExistingNetworkRG.location
  resource_group_name = data.azurerm_resource_group.ExistingNetworkRG.name
  #public_ip_address_allocation = "dynamic" # deprecated
  allocation_method = "Dynamic"
  sku               = "Basic"
}
# create a network interface
resource "azurerm_network_interface" "ExistingNetworkRG" {
  name                = "supdevopstts-RG-TF-VM-Network"
  location            = data.azurerm_resource_group.ExistingNetworkRG.location
  resource_group_name = data.azurerm_resource_group.ExistingNetworkRG.name
  ip_configuration {
    name                          = "supdevopstts"
    subnet_id                     = data.azurerm_subnet.ExistingNetworkRG.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ExistingNetworkRG.id
  }
}
/**********************************************************
#Create Boot Diagnostic Account
resource "azurerm_storage_account" "sa" {
name = "vmdiag4tf"
resource_group_name = "RG-TF-SA-Storage"
location = "southeastasia"
account_tier = "Standard"
account_replication_type = "LRS"
tags = {
environment = "Boot Diagnostic Storage"
CreatedBy = "Admin"
}
}
**********************************************************/
# Create virtual machine
resource "azurerm_virtual_machine" "ExistingNetworkRG" {
  name                             = "supdevopstts" # This is the VM Name in Azure Portal
  location                         = data.azurerm_resource_group.ExistingVMRG.location
  resource_group_name              = data.azurerm_resource_group.ExistingVMRG.name
  network_interface_ids            = ["${azurerm_network_interface.ExistingNetworkRG.id}"]
  vm_size                          = "Standard_B2ms"
  delete_os_disk_on_termination    = true # It will delete when we destroy
  delete_data_disks_on_termination = true # We don't have to worry about costs


  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

/*

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "22_04-lts-gen2"
    version   = "22.04.202310040"
  }


  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "20.04.202308310"
  }

storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-avd"
    version   = "latest"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-10"
    sku       = "win10-21h2-avd"
    version   = "latest"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  

*/



  storage_os_disk {
    name              = "supdevopstts"
    disk_size_gb      = "128"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "supdevopstts" # This is the OS name - login prompt
    admin_username = "suparuek"
    admin_password = "Password12345!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    ShutDownTime = "6pmStop"
    StartUpTime  = "6amStart"
    environment  = "Production"
    CreatedBy    = "VSCode on Suparuek Mac"
    ProjectName  = "TERRAFORM4AZUREINF"
    TFStateFile  = "Local on Suparuek Mac"
  }


  /*
boot_diagnostics {
enabled = "true"
storage_uri = azurerm_storage_account.sa.primary_blob_endpoint
}
*/
  /*
*************************************************
คำสั่งที่ใช้กับ terraform
*************************************************
คำสั่ง init รันแค่ครั้งแรกครั้งเดี่ยวเพื่อ load software มาจาก terraform website
terraform init
คำสั่ง plan เป็นการบอกว่าจะสร้าง(ทำอะไรบ้าง) นอกจากนี้ยังช่วยเช็คว่าพิมพ์คำสั่งผิดหรือไม่ ทุกครั้งที่แก้ code
terraform plan
คำสั่ง apply เป็นการสั่งให้มันสร้างขึ้นมา --auto-approve เพื่อที่จะได้ไม่ต้องมาตอบ yes เพื่อ confirm
terraform apply --auto-approve
คำสั่ง destroy จะใช้เมื่อเราต้องการลบทุกอย่างทิ้ง และถ้าจะสร้างใหม่ต้องรัน plan และ apply เพื่อสร้างใหม่
terraform destroy --auto-approve

ดูชื่อ az vm image list --location southeastasia --all --publisher="Canonical" --sku="20_04-lts-gen2"

*************************************************
*/
}


data "azurerm_virtual_machine" "ExistingNetworkRG" {
  name                = "${azurerm_virtual_machine.ExistingNetworkRG.name}"
  resource_group_name = "${azurerm_virtual_machine.ExistingNetworkRG.resource_group_name}"
}


resource "null_resource" "chrony" {
  connection {
    type = "ssh"
    user = "suparuek"
    password = "Password12345!"
    host = "${data.azurerm_virtual_machine.ExistingNetworkRG.public_ip_address}"
  }
  provisioner "file" {
    source = "/home/suparuek/terraform-azure-15-06-20023/4-VMs/ubuntu2204/install.sh"
    destination = "/tmp/install.sh"
  }
  provisioner "remote-exec" {
    #connection {
    #  type = "ssh"
    #  user = "suparuek"
    #  password = "Password12345!"
    #  host = "${data.azurerm_virtual_machine.ExistingNetworkRG.public_ip_address}"
    #}
    inline = [
      "sudo sh /tmp/install.sh",
    ]
  }
}
