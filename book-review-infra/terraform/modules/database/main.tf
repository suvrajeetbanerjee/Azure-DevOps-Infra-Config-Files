// terraform {
//   required_providers {
//     azurerm = {
//       source  = "hashicorp/azurerm"
//       version = "~> 4.53.0"
//     }
//   }
// }

// provider "azurerm" {
//   features {}
// }

# Public IP for MySQL VM
resource "azurerm_public_ip" "mysql_pip" {
  name                = "DevOps1-pm1-dev-mysql-pip"
  location            = var.location
  resource_group_name = var.resource_group_name

  allocation_method = "Static"
  sku               = "Standard"
  sku_tier          = "Regional"

  # Optional: uncomment and adjust if you want a DNS name
  # domain_name_label = "devops1-pm1-dev-mysql"
}

# NIC for MySQL VM
resource "azurerm_network_interface" "mysql_nic" {
  name                = "DevOps1-pm1-dev-mysql-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mysql_pip.id
  }
}

# Linux VM that will host MySQL
resource "azurerm_linux_virtual_machine" "mysql_vm" {
  name                = "DevOps1-pm1-dev-mysql-vm"
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.mysql_vm_size

  network_interface_ids = [
    azurerm_network_interface.mysql_nic.id
  ]

  admin_username                  = var.mysql_admin_username
  admin_password                  = var.mysql_admin_password
  disable_password_authentication = false

  os_disk {
    name                 = "DevOps1-pm1-dev-mysql-vm-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # Optional – you can later plug in cloud-init/Ansible to install MySQL
}

# Outputs for this module
output "mysql_fqdn" {
  description = "DNS or IP to reach the MySQL server from app"
  # If you set domain_name_label above, use .fqdn instead
  # value = azurerm_public_ip.mysql_pip.fqdn
  value = azurerm_public_ip.mysql_pip.ip_address
}

output "mysql_vm_public_ip" {
  description = "Public IP address of the MySQL VM"
  value       = azurerm_public_ip.mysql_pip.ip_address
}

output "mysql_vm_private_ip" {
  description = "Private IP address of the MySQL VM"
  value       = azurerm_network_interface.mysql_nic.private_ip_address
}
