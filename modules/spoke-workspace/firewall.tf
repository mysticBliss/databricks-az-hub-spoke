
resource "azurerm_route_table" "adbroute" {
  // route all traffic from spoke vnet to hub vnet
  name                = "spoke-routetable"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  route {
    name                   = "to-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    # next_hop_in_ip_address = azurerm_firewall.hubfirewall.ip_configuration.0.private_ip_address // extract single item
    next_hop_in_ip_address = var.hubfirewall.ip_configuration.0.private_ip_address // extract single item
  }
}


## Define UDR for Public Subnet ~ Routing traffic to Hub Firewall
resource "azurerm_subnet_route_table_association" "publicudr" {
  subnet_id      = azurerm_subnet.public.id
  route_table_id = azurerm_route_table.adbroute.id
}


## Define UDR for Private Subnet ~ Routing traffic to Hub Firewall
resource "azurerm_subnet_route_table_association" "privateudr" {
  subnet_id      = azurerm_subnet.private.id
  route_table_id = azurerm_route_table.adbroute.id
}

