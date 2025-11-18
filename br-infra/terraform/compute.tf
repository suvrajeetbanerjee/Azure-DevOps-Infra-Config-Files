resource "azurerm_public_ip" "frontend_pip" {
  name                = "${var.prefix}-frontend-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_public_ip" "backend_pip" {
  name                = "${var.prefix}-backend-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "frontend_nic" {
  name                = "${var.prefix}-frontend-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    public_ip_address_id          = azurerm_public_ip.frontend_pip.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "backend_nic" {
  name                = "${var.prefix}-backend-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    public_ip_address_id          = azurerm_public_ip.backend_pip.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "frontend_vm" {
  name                = "${var.prefix}-frontend-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B1s"
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.frontend_nic.id
  ]

  disable_password_authentication = false
  admin_password                  = var.admin_password

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("${path.module}/id_rsa.pub")
  }

  os_disk {
    name                 = "${var.prefix}-frontend-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}


// resource "azurerm_linux_virtual_machine" "frontend_vm" {
//   name                = "${var.prefix}-frontend-vm"
//   resource_group_name = azurerm_resource_group.rg.name
//   location            = var.location
//   size                = "Standard_B1ms"
//   admin_username      = var.admin_username
//   admin_password      = var.admin_password
//   disable_password_authentication = false
//   network_interface_ids = [azurerm_network_interface.frontend_nic.id]

//   source_image_reference {
//     publisher = "Canonical"
//     offer     = "0001-com-ubuntu-server-jammy"
//     sku       = "22_04-lts"
//     version   = "latest"
//   }
// }

// resource "azurerm_linux_virtual_machine" "backend_vm" {
//   name                = "${var.prefix}-backend-vm"
//   resource_group_name = azurerm_resource_group.rg.name
//   location            = var.location
//   size                = "Standard_B1ms"
//   admin_username      = var.admin_username
//   admin_password      = var.admin_password
//   disable_password_authentication = false
//   network_interface_ids = [azurerm_network_interface.backend_nic.id]

//   source_image_reference {
//     publisher = "Canonical"
//     offer     = "0001-com-ubuntu-server-jammy"
//     sku       = "22_04-lts"
//     version   = "latest"
//   }
// }


resource "azurerm_linux_virtual_machine" "backend_vm" {
  name                = "${var.prefix}-backend-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B1s"
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.backend_nic.id
  ]

  disable_password_authentication = false
  admin_password                  = var.admin_password

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("${path.module}/id_rsa.pub")
  }

  os_disk {
    name                 = "${var.prefix}-backend-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
