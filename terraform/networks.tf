/**
 * This Terraform file defines the networking resources for an Azure Load Balancer.
 * It includes the creation of a virtual network, a subnet, and a network security group.
 * Also includes the creation of two publics IPs for the Load Balancer and the NAT Gateway.
 */

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["192.168.1.0/27"]
}

resource "azurerm_subnet" "backend_subnet" {
  name                 = var.backend_subnet
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.1.0/28"]
}

resource "azurerm_network_security_group" "my_nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  security_rule {
    name                       = "NSGRuleHTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "lb_ip" {
  name                = "lb_ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "nat_gw_ip" {
  name                = "nat_gw_ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}