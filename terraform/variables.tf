/**
 * This file contains the variable declarations for the Terraform configuration.
 * It defines various variables used to configure the deployment of Azure resources.
 */

variable "resource_group_location" {
  type        = string
  description = "The location of the resource group"
  default     = "eastus"
}

variable "resource_group_name_prefix" {
  type        = string
  description = "The prefix of the resource group name"
  default     = "rg"
}

variable "username" {
  type        = string
  description = "The username for the VM"
  default     = "adminschedule"
}

variable "vnet" {
  type        = string
  description = "The name of the virtual network"
  default     = "vnet-practice"
}

variable "backend_subnet" {
  type        = string
  description = "The name of the backend subnet"
  default     = "backend-subnet"
}

variable "nsg_name" {
  type        = string
  description = "The name of the network security group"
  default     = "NSG_practice"
}

variable "lb_name" {
  type        = string
  description = "The name of the load balancer"
  default     = "lb-practice"
}