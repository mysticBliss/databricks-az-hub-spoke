resource "azurerm_virtual_network_peering" "hubvnet" {
  name                      = "peerhubtospoke"
  resource_group_name       = var.hubvnet.resource_group_name
  virtual_network_name      = var.hubvnet.name
  remote_virtual_network_id = azurerm_virtual_network.this.id # spoke vnet id
}

resource "azurerm_virtual_network_peering" "spokevnet" {
  name                      = "peerspoketohub"
  resource_group_name       = azurerm_resource_group.this.name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = var.hubvnet.id
}