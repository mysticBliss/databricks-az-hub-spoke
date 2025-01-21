data "azurerm_resource_group" "hub_rg" {
  name = var.hub_rg_name
}

data "azurerm_virtual_network" "hub_vnet" {
  name = var.hub_vnet_name
  resource_group_name = data.azurerm_resource_group.hub_rg.name
  
}

resource "azurerm_virtual_network_peering" "hubvnet" {
  name                      = "peerhubtospoke"
  resource_group_name       = data.azurerm_virtual_network.hub_vnet.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.this.id # spoke vnet id
}

resource "azurerm_virtual_network_peering" "spokevnet" {
  name                      = "peerspoketohub"
  resource_group_name       = azurerm_resource_group.rg_connectivity.name
  virtual_network_name      = azurerm_virtual_network.this.name # spoke vnet id
  remote_virtual_network_id = data.azurerm_virtual_network.hub_vnet.id
}