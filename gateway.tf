/**
 * This Terraform configuration file defines the resources for creating a NAT gateway in Azure.
 * 
 * Resources:
 * - azurerm_nat_gateway: Represents a NAT gateway resource that provides outbound connectivity for resources in a virtual network.
 * - azurerm_nat_gateway_public_ip_association: Associates a public IP address with a NAT gateway.
 * - azurerm_subnet_nat_gateway_association: Associates a subnet with a NAT gateway.
 */

resource "azurerm_nat_gateway" "nat_gw" {
  name                    = "nat_gw"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gw_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gw.id
  public_ip_address_id = azurerm_public_ip.nat_gw_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "nat_gw_association" {
  subnet_id      = azurerm_subnet.backend_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}