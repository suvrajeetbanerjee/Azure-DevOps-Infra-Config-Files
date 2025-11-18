variable "location" {
  default = "Central India"
}

variable "prefix" {
  default = "bookapp"
}

variable "admin_username" {
  default = "azureuser"
}

variable "admin_password" {
  default = "P@ssword1234!"
}

variable "db_user" {
  default = "mysqladmin"
}

variable "db_password" {
  default = "DevSecureDBPassword123!"
}

variable "db_name" {
  default = "book_review_db"
}


variable "ssh_public_key" {
  description = "Public SSH key"
}
