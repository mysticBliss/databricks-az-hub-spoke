/**
 * Azure Databricks workspace in custom VNet
 *
 * Module creates:
 * * Resource group with random prefix
 * * Tags, including `Owner`, which is taken from `az account show --query user`
 * * VNet with Firewall
 */


# Generate a random string for resource naming
resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

# Data source to get the current Azure client configuration
data "azurerm_client_config" "current" {
}

# Data source to get the current user's account information
data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}

locals {
  # Local variables for resource naming and configuration
  prefix   = join("-", [var.workspace_prefix, "${random_string.naming.result}"])  # Prefix for resources
  location = var.rglocation  # Location for the resource group
  

  // Tags that are propagated down to all resources
  tags = merge({
    Owner = lookup(data.external.me.result, "name")  # Owner of the resources
    Epoch = random_string.naming.result  # Random string for uniqueness
  }, var.tags)
}

resource "azurerm_resource_group" "this" {
  name     = "adb-hub-${local.prefix}-rg"  # Name of the Hub resource group
  location = local.location  # Location of the Hub  resource group
  tags     = local.tags  # Tags for the Hub resource group
}
