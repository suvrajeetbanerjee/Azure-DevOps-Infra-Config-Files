output "frontend_ip" {
  value = azurerm_public_ip.frontend_pip.ip_address
}

output "backend_ip" {
  value = azurerm_public_ip.backend_pip.ip_address
}

output "mysql_fqdn" {
  value = azurerm_public_ip.mysql_pip.ip_address
}
