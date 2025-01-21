# Resource Group for DNS
resource "azurerm_resource_group" "rg_dns" {
  name     = "all-dns-${var.prefix}-${var.env}-${var.suffix}"
  location = var.rglocation
}



/**
 * Private DNS zone for the Databricks private endpoint.
 * This zone is used to resolve the private link endpoint.
 */
resource "azurerm_private_dns_zone" "dnsdpcp" {
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = azurerm_resource_group.rg_dns.name
}



# Azure Blob Storage Private DNS Zone
resource "azurerm_private_dns_zone" "dnsdbfs_blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_dns.name
}

# Azure Data Lake Storage (DFS) Private DNS Zone
resource "azurerm_private_dns_zone" "dnsdbfs_dfs" {
  name                = "privatelink.dfs.core.windows.net"
  resource_group_name = azurerm_resource_group.rg_dns.name
}

# Virtual Links

//**
// * Link between the private DNS zone and the spoke virtual network.
// * This allows the virtual network to resolve the private link endpoint.
// */
resource "azurerm_private_dns_zone_virtual_network_link" "dpcpdnszonevnetlink" {
  name                  = "dpcpspokevnetconnection"
  resource_group_name   = azurerm_resource_group.rg_dns.name
  private_dns_zone_name = azurerm_private_dns_zone.dnsdpcp.name
  virtual_network_id    = azurerm_virtual_network.this.id // connect to spoke VNet
}

resource "azurerm_private_dns_zone_virtual_network_link" "dbfsdnszonevnetlink_blob" {
  name                  = "dbfsspokevnetconnection-blob"
  resource_group_name   = azurerm_resource_group.rg_dns.name
  private_dns_zone_name = azurerm_private_dns_zone.dnsdbfs_blob.name
  virtual_network_id    = azurerm_virtual_network.this.id // connect to spoke VNet
}


resource "azurerm_private_dns_zone_virtual_network_link" "dbfsdnszonevnetlink_dfs" {
  name                  = "dbfsspokevnetconnection-dfs"
  resource_group_name   = azurerm_resource_group.rg_dns.name
  private_dns_zone_name = azurerm_private_dns_zone.dnsdbfs_dfs.name
  virtual_network_id    = azurerm_virtual_network.this.id // connect to spoke VNet
}

