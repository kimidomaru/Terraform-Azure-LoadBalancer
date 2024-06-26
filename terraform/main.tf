/**
 * This Terraform configuration file creates a random pet name and uses it as the name for an Azure resource group.
 * 
 * The `random_pet` resource generates a random pet name using the `prefix` variable defined in the configuration.
 * 
 * The `azurerm_resource_group` resource creates an Azure resource group with the name generated by the `random_pet` resource.
 * The location of the resource group is specified by the `resource_group_location` variable.
 */
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  name     = random_pet.rg_name.id
  location = var.resource_group_location
}
