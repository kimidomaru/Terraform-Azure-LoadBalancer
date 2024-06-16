/*
  This Terraform configuration file defines the resources required to create an Azure Load Balancer.
  It includes the following resources:
  - azurerm_lb: Defines the load balancer itself.
  - azurerm_lb_backend_address_pool: Defines the backend pool for the load balancer.
  - azurerm_lb_probe: Defines the health probe for the load balancer.
  - azurerm_lb_rule: Defines the load balancing rule for the load balancer.
*/

resource "azurerm_lb" "loadbalancer" {
  name                = var.lb_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "frontEnd"
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
}

// Define the backend pool for the load balancer
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  name            = "backEndPool"
  loadbalancer_id = azurerm_lb.loadbalancer.id
}

// Define the health probe for the load balancer
resource "azurerm_lb_probe" "loadbalancer_probe" {
  loadbalancer_id     = azurerm_lb.loadbalancer.id
  resource_group_name = azurerm_resource_group.rg.name
  name                = "healthProbe"
  port                = 80
  protocol            = "Tcp"
}

// Define the load balancing rule for the load balancer
resource "azurerm_lb_rule" "loadbalancer_rule" {
  name                           = "httpRule"
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  probe_id                       = azurerm_lb_probe.loadbalancer_probe.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontEnd"
  disable_outbound_snat          = true
  idle_timeout_in_minutes        = 15
  enable_tcp_reset               = true
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  resource_group_name            = azurerm_resource_group.rg.name
}