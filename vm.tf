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
/*
variable "subscription_id" {
  description = "Subscription ID"
  type        = string
}

variable "client_id" {
  description = "Client ID"
  type        = string
}

variable "client_secret" {
  description = "SPN secret"
  type        = string
}

variable "tenant_id" {
  description = "Tenant ID"
  type        = string
}
*/

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


resource "azurerm_linux_virtual_machine" "example" {
  name                            = var.vm_name
  location                        = "westus"
  resource_group_name             = var.resource_group_name
  size                            = "Standard_DS1_v2"
  computer_name                   = var.vm_name
  admin_username                  = "gitlabtesting"
  admin_password                  = "admin@12345"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  tags = {
    Kyndryl_Managed = "true"
    practice        = "cloud"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
