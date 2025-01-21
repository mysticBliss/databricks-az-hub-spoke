locals {
  service_delegation_actions = [
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
    "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
  ]
}

# Public Subnet
resource "azurerm_subnet" "public" {
  name                 = "snet-public-${var.prefix}-${var.env}-${var.suffix}"
  resource_group_name  = azurerm_resource_group.rg_connectivity.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.spokecidr, 3, 0)]

  delegation {
    name = "databricks"
    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = local.service_delegation_actions
    }
  }
}

# Private Subnet
resource "azurerm_subnet" "private" {
  name                 = "snet-private-${var.prefix}-${var.env}-${var.suffix}"
  resource_group_name  = azurerm_resource_group.rg_connectivity.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.spokecidr, 3, 1)]

  private_endpoint_network_policies = "Enabled"

  delegation {
    name = "databricks"
    service_delegation {
      name    = "Microsoft.Databricks/workspaces"
      actions = local.service_delegation_actions
    }
  }

  service_endpoints = var.private_subnet_endpoints
}


# Private Link Subnet
resource "azurerm_subnet" "plsubnet" {
  name                              = "snet-privatelink-${var.prefix}-${var.env}-${var.suffix}"
  resource_group_name               = azurerm_resource_group.rg_connectivity.name
  virtual_network_name              = azurerm_virtual_network.this.name
  address_prefixes                  = [cidrsubnet(var.spokecidr, 3, 2)]
  private_endpoint_network_policies = "Enabled"
}
