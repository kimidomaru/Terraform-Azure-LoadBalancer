/*
  This Terraform file defines the configuration for creating Azure virtual machines (VMs) and associated resources.
  It creates network interfaces, backend address pool associations, security group associations, storage accounts,
  and Linux virtual machines.

  The `locals` block defines a variable `vms` which is an array of VM names.

  The `azurerm_network_interface` resource block creates network interfaces for each VM in the `vms` array.
  It associates the network interface with a subnet and assigns a dynamic private IP address.

  The `azurerm_network_interface_backend_address_pool_association` resource block associates the network interface
  with a backend address pool of an Azure Load Balancer.

  The `azurerm_network_interface_security_group_association` resource block associates the network interface
  with a network security group.

  The `random_id` resource block generates random IDs for each VM.

  The `azurerm_storage_account` resource block creates storage accounts for each VM.
  It specifies the account tier and replication type.

  The `azurerm_linux_virtual_machine` resource block creates Linux virtual machines for each VM.
  It specifies the VM size, network interface, OS disk, source image, computer name, admin username, admin SSH key,
  and boot diagnostics storage account.

*/

locals {
  vms = ["vm1", "vm2"]
}

resource "azurerm_network_interface" "vms_nic" {
  for_each = toset(local.vms)

  name                = "${each.key}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic${each.key}Configuration"
    subnet_id                     = azurerm_subnet.backend_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "vms_nic_association" {
  for_each = toset(local.vms)

  network_interface_id    = azurerm_network_interface.vms_nic[each.key].id
  ip_configuration_name   = azurerm_network_interface.vms_nic[each.key].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}

resource "azurerm_network_interface_security_group_association" "vms_nsg_association" {
  for_each = toset(local.vms)

  network_interface_id      = azurerm_network_interface.vms_nic[each.key].id
  network_security_group_id = azurerm_network_security_group.my_nsg.id
}

resource "random_id" "random_vm_ids" {
  for_each = toset(local.vms)
  keepers = {
    resource_group = azurerm_resource_group.rg.name
  }
  byte_length = 8
}


resource "azurerm_storage_account" "storage_account_vms" {
  for_each                 = toset(local.vms)
  name                     = "diag${random_id.random_vm_ids[each.key].hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_linux_virtual_machine" "vms" {
  for_each = toset(local.vms)

  name                  = each.key
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_DS1_v2"
  network_interface_ids = [azurerm_network_interface.vms_nic[each.key].id]
  os_disk {
    name                 = "${each.key}-Osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  computer_name  = each.key
  admin_username = var.username
  admin_ssh_key {
    username   = var.username
    public_key = azapi_resource_action.ssh_public_key_gen.output.publicKey
  }
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage_account_vms[each.key].primary_blob_endpoint
  }
}