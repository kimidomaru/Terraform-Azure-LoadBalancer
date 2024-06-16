// Create a subnet for the Azure Bastion service
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.1.16/28"]
}

// Create a public IP address for the Azure Bastion service
resource "azurerm_public_ip" "bastion_public_ip" {
  name                = "bastionPublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

// Create an Azure Bastion host
resource "azurerm_bastion_host" "bastion_host" {
  name                = "bastionHost"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"

  // Configure the IP address for the Azure Bastion host
  ip_configuration {
    name                 = "bastionIpConfiguration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
  }
}