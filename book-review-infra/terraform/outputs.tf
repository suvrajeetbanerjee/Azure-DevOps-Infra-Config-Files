output "backend_public_ip" {
  value = module.compute.backend_public_ip
}

output "frontend_public_ip" {
  value = module.compute.frontend_public_ip
}

output "mysql_fqdn" {
  # now coming from the VM-based DB module
  value = module.database.mysql_fqdn
}

output "nsg_id" {
  value = module.network.nsg_id
}

output "public_subnet_id" {
  value = module.network.public_subnet_id
}









// output "frontend_public_ip" {
//   value = module.compute.frontend_public_ip
// }

// output "backend_public_ip" {
//   value = module.compute.backend_public_ip
// }

// output "public_subnet_id" {
//   value = module.network.public_subnet_id
// }

// output "nsg_id" {
//   value = module.network.nsg_id
// }

// output "mysql_fqdn" {
//   value = module.database.mysql_fqdn
// }
