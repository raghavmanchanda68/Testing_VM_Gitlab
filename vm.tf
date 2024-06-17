variable "vm_name" {
  description = "The name of the VM"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "nic_name" {
  description = "The name of the network interface"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

resource "azurerm_network_interface" "example" {
  name                = var.nic_name
  location            = "westus"
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_virtual_network" "example" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = "westus"
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-MOCPEDemo-kcl-westus-003"
    storage_account_name = "gitlabtf"
    container_name       = "gitlab-cont"
    key                  = "test.terraform.tfstate"
  }
}
provider "azurerm" {

  features {
  }

}


resource "azurerm_linux_virtual_machine" "example" {
  name                            = var.vm_name
  location                        = "westus"
  resource_group_name             = var.resource_group_name
  size                            = "Standard_DS1_v2"
  computer_name                   = var.vm_name
  admin_username                  = "mysecureadmin"
  admin_password                  = "Admin@12345"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}
