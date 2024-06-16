/**
 * This file contains the output definitions for the Terraform Azure Load Balancer module.
 * It defines the outputs for the resource group name, load balancer IP address, bastion IP address,
 * and the private IP addresses of two virtual machines (vm1 and vm2).
 */

output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "lb_ip_address" {
  value = azurerm_public_ip.lb_ip.*.ip_address
}

output "bastion_ip_address" {
  value = azurerm_public_ip.bastion_public_ip.*.ip_address
}

output "vm1_private_ip_address" {
  value = azurerm_linux_virtual_machine.vms["vm1"].private_ip_address
}

output "vm2_private_ip_address" {
  value = azurerm_linux_virtual_machine.vms["vm2"].private_ip_address
}