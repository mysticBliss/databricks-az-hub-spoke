resource "azurerm_virtual_network" "hubvnet" {
  // VNet for hub resource group
  name                = "${local.prefix}-hub-vnet"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = [var.hubcidr]
  tags                = local.tags
}

resource "azurerm_subnet" "hubfw" {
  // Name must be fixed as AzureFirewallSubnet
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.hubvnet.name
  address_prefixes     = [cidrsubnet(var.hubcidr, 2, 0)]  // Changed to /26 for Azure Firewall
}
