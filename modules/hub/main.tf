/**
 * Hub Creation with custom VNet
 *
 * Module creates:
 * * Resource group with commbination of prefix, suffix and location
 * * VNet with Firewall
 */


locals {
  prefix   = "${var.prefix}-hub"
  env      = var.env
  suffix   = "${var.rglocation}${var.suffix}"
  location = var.rglocation
}

resource "azurerm_resource_group" "hub_connectivity_rg" {
  name = "rg-${local.prefix}-${local.env}-${local.suffix}"  // Name of the Hub resource group
  location = local.location  // Location of the Hub resource group
  tags     = var.tags  // Tags for the Hub resource group
}


