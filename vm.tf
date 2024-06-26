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
variable "username" {
  description = "The name of the VM"
  type        = string
  default = "cprabhat"
}
variable "password" {
  description = "The name of the VM"
  type        = string
  default = "Raghav@12345"
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


resource "azurerm_windows_virtual_machine" "example" {
  name                            = var.vm_name
  location                        = "westus"
  resource_group_name             = var.resource_group_name
  size                            = "Standard_DS1_v2"
  computer_name                   = var.vm_name
  admin_username                  = var.username
  admin_password                  = var.password

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
