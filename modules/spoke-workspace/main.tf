/**
 * Azure Databricks workspace in custom VNet
 *
 * Module creates:
 * * VNet with public and private subnet
 * * Vnet for VM and private links
 * * Databricks workspace
 */


locals {
  prefix   = "${var.prefix}-hub"
  env      = var.env
  suffix   = "${var.rglocation}${var.suffix}"
  location = var.rglocation
}

resource "azurerm_resource_group" "this" {
  name = "rg-${local.prefix}-${local.env}-${local.suffix}"  // Name of the Hub resource group
  location = var.rglocation  // Location of the Hub resource group
  tags     = var.tags  // Tags for the Hub resource group
}

