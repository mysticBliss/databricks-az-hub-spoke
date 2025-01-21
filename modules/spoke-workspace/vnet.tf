
# Connectivity Resource Group
resource "azurerm_resource_group" "rg_connectivity" {
  name     = "rg-connectivity-${var.prefix}-${var.env}-${var.suffix}"
  location = var.rglocation
}

# locals {
#   service_delegation_actions = [
#     "Microsoft.Network/virtualNetworks/subnets/join/action",
#     "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
#     "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
#   ]
# }

# Virtual Network
resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.prefix}-${var.env}-${var.suffix}"
  location            = azurerm_resource_group.rg_connectivity.location
  resource_group_name = azurerm_resource_group.rg_connectivity.name
  address_space       = [var.spokecidr]
  tags                = var.tags
}

# # Network Security Group
# resource "azurerm_network_security_group" "this" {
#   name                = "nsg-${var.prefix}-${var.env}-${var.suffix}"
#   location            = azurerm_resource_group.rg_connectivity.location
#   resource_group_name = azurerm_resource_group.rg_connectivity.name
#   tags                = var.tags
# }

# # Public Subnet
# resource "azurerm_subnet" "public" {
#   name                 = "snet-public-${var.prefix}-${var.env}-${var.suffix}"
#   resource_group_name  = azurerm_resource_group.rg_connectivity.name
#   virtual_network_name = azurerm_virtual_network.this.name
#   address_prefixes     = [cidrsubnet(var.spokecidr, 3, 0)]

#   delegation {
#     name = "databricks"
#     service_delegation {
#       name    = "Microsoft.Databricks/workspaces"
#       actions = local.service_delegation_actions
#     }
#   }
# }

# resource "azurerm_subnet_network_security_group_association" "public" {
#   subnet_id                 = azurerm_subnet.public.id
#   network_security_group_id = azurerm_network_security_group.this.id
# }

# # Private Subnet
# resource "azurerm_subnet" "private" {
#   name                 = "snet-private-${var.prefix}-${var.env}-${var.suffix}"
#   resource_group_name  = azurerm_resource_group.rg_connectivity.name
#   virtual_network_name = azurerm_virtual_network.this.name
#   address_prefixes     = [cidrsubnet(var.spokecidr, 3, 1)]

#   private_endpoint_network_policies = "Enabled"

#   delegation {
#     name = "databricks"
#     service_delegation {
#       name    = "Microsoft.Databricks/workspaces"
#       actions = local.service_delegation_actions
#     }
#   }

#   service_endpoints = var.private_subnet_endpoints
# }

# resource "azurerm_subnet_network_security_group_association" "private" {
#   subnet_id                 = azurerm_subnet.private.id
#   network_security_group_id = azurerm_network_security_group.this.id
# }

# # Private Link Subnet
# resource "azurerm_subnet" "plsubnet" {
#   name                              = "snet-privatelink-${var.prefix}-${var.env}-${var.suffix}"
#   resource_group_name               = azurerm_resource_group.rg_connectivity.name
#   virtual_network_name              = azurerm_virtual_network.this.name
#   address_prefixes                  = [cidrsubnet(var.spokecidr, 3, 2)]
#   private_endpoint_network_policies = "Enabled"
# }
