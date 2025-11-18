resource "azurerm_public_ip" "mysql_pip" {
  name                = "${var.prefix}-mysql-pip"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "mysql_nic" {
  name                = "${var.prefix}-mysql-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mysql_pip.id
  }
}


resource "azurerm_linux_virtual_machine" "mysql_vm" {
  name                = "${var.prefix}-mysql-vm"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B1s"
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.mysql_nic.id
  ]

  disable_password_authentication = false
  admin_password                  = var.admin_password

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("${path.module}/id_rsa.pub")
  }

  os_disk {
    name                 = "${var.prefix}-mysql-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(<<EOF
#!/bin/bash
apt update -y
apt install -y mysql-server

sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql

mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${var.db_password}'; FLUSH PRIVILEGES;"

mysql -u root -p${var.db_password} -e "CREATE USER IF NOT EXISTS '${var.db_user}'@'%' IDENTIFIED BY '${var.db_password}';"
mysql -u root -p${var.db_password} -e "CREATE DATABASE IF NOT EXISTS ${var.db_name};"
mysql -u root -p${var.db_password} -e "GRANT ALL PRIVILEGES ON *.* TO '${var.db_user}'@'%'; FLUSH PRIVILEGES;"
EOF
  )
}


// resource "azurerm_linux_virtual_machine" "mysql_vm" {
//   name                = "${var.prefix}-mysql-vm"
//   location            = var.location
//   resource_group_name = azurerm_resource_group.rg.name
//   size                = "Standard_B1ms"
//   admin_username      = var.admin_username
//   admin_password      = var.admin_password
//   disable_password_authentication = false
//   network_interface_ids = [azurerm_network_interface.mysql_nic.id]

//   source_image_reference {
//     publisher = "Canonical"
//     offer     = "0001-com-ubuntu-server-jammy"
//     sku       = "22_04-lts"
//     version   = "latest"
//   }

//   custom_data = base64encode(<<EOF
// #!/bin/bash
// apt update -y
// apt install -y mysql-server

// sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
// systemctl restart mysql

// mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${var.db_password}'; FLUSH PRIVILEGES;"

// mysql -u root -p${var.db_password} -e "CREATE USER IF NOT EXISTS '${var.db_user}'@'%' IDENTIFIED BY '${var.db_password}';"
// mysql -u root -p${var.db_password} -e "CREATE DATABASE IF NOT EXISTS ${var.db_name};"
// mysql -u root -p${var.db_password} -e "GRANT ALL PRIVILEGES ON *.* TO '${var.db_user}'@'%'; FLUSH PRIVILEGES;"
// EOF
//   )
// }
