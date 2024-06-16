/*
  This Terraform configuration file defines the resources required to generate an SSH key pair in Azure.

  Resources:
  - random_pet.ssh_key: Generates a random pet name to be used as the prefix for the SSH key.
  - azapi_resource_action.ssh_public_key_gen: Calls the Azure API to generate an SSH key pair.
  - azapi_resource.ssh_public_key: Defines the Azure API resource for the SSH public key.
  - local_file.ssh_private_key: Writes the generated SSH private key to a local file.

  Note: Make sure to replace the FILEPATH placeholder with the actual file path where this code is located.
*/
resource "random_pet" "ssh_key" {
  prefix    = "ssh"
  separator = ""
}

resource "azapi_resource_action" "ssh_public_key_gen" {
  type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  resource_id = azapi_resource.ssh_public_key.id
  action      = "generateKeyPair"
  method      = "POST"

  response_export_values = ["publicKey", "privateKey"]
}

resource "azapi_resource" "ssh_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  name      = random_pet.ssh_key.id
  location  = azurerm_resource_group.rg.location
  parent_id = azurerm_resource_group.rg.id
}

resource "local_file" "ssh_private_key" {
  content  = azapi_resource_action.ssh_public_key_gen.output.publicKey
  filename = "ssh_private_key.pem"
}