variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region for resources"
}

# Subnet where the MySQL VM will live (use the public subnet)
variable "subnet_id" {
  type        = string
  description = "Subnet ID for the MySQL VM NIC"
}

variable "mysql_admin_username" {
  type        = string
  description = "Admin username for MySQL VM OS"
}

variable "mysql_admin_password" {
  type        = string
  description = "Admin password for MySQL VM OS"
  sensitive   = true
}

variable "mysql_vm_size" {
  type        = string
  description = "Size of the MySQL VM"
  default     = "Standard_B1ms"
}




// variable "location" {}
// variable "mysql_admin_username" {}
// variable "mysql_admin_password" {
//   sensitive = true
// }
// variable "mysql_database_name" {}
// variable "resource_group_name" {}
// variable "backend_vm_public_ip" {}
