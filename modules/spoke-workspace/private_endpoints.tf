# Resource Group for Private Endpoints
resource "azurerm_resource_group" "rg_private_endpoint" {
  name     = "rg-private-endpoint-${var.prefix}-${var.env}-${var.suffix}"
  location = var.rglocation
}

# Azure Active Directory Authentication Private Endpoint
resource "azurerm_private_endpoint" "auth" {
  name                = "pvt-endpoint-auth-${var.prefix}-${var.env}-${var.suffix}"
  location            = azurerm_resource_group.rg_private_endpoint.location
  resource_group_name = azurerm_resource_group.rg_private_endpoint.name
  subnet_id           = azurerm_subnet.plsubnet.id // private link subnet, in Databricks spoke VNet

  private_service_connection {
    name                           = "ple-auth-${var.prefix}-${var.env}-${var.suffix}"
    private_connection_resource_id = azurerm_databricks_workspace.this.id
    is_manual_connection           = false
    subresource_names              = ["browser_authentication"]
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-auth"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsdpcp.id]
  }
}



# Databricks UI API Private Endpoint
resource "azurerm_private_endpoint" "dp_dpcp" {
  name                = "pvt-endpoint-febe-${var.prefix}-${var.env}-${var.suffix}"
  location            = azurerm_resource_group.rg_private_endpoint.location
  resource_group_name = azurerm_resource_group.rg_private_endpoint.name
  subnet_id           = azurerm_subnet.plsubnet.id

  private_service_connection {
    name                           = "ple-dp-dpcp-${var.prefix}-${var.env}-${var.suffix}"
    private_connection_resource_id = azurerm_databricks_workspace.this.id
    is_manual_connection           = false
    subresource_names              = ["databricks_ui_api"]
  }
  private_dns_zone_group {
    name                 = "private-dns-zone-dpcp"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsdpcp.id]
  }
}


## Storage resource group
# Azure Blob Storage Private Endpoint
resource "azurerm_private_endpoint" "dbfspe_blob" {
  name                = "pvt-endpoint-blob-${var.prefix}-${var.env}-${var.suffix}"
  location            = azurerm_resource_group.storage_accounts.location
  resource_group_name = azurerm_resource_group.storage_accounts.name
  subnet_id           = azurerm_subnet.plsubnet.id // private link subnet, in Databricks spoke VNet

  private_service_connection {
    name                           = "ple-dbfs-blob-snet-public-${var.prefix}-${var.env}-${var.suffix}"
    private_connection_resource_id = join("", [azurerm_databricks_workspace.this.managed_resource_group_id, "/providers/Microsoft.Storage/storageAccounts/${var.dbfsname}"])
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
  private_dns_zone_group {
    name                 = "private-dns-zone-blob"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsdbfs_blob.id]
  }
}

# Azure Data Lake Storage (DFS) Private Endpoint
resource "azurerm_private_endpoint" "dbfspe_dfs" {
  name                = "pvt-endpoint-dfs-${var.prefix}-${var.env}-${var.suffix}"
  location            = azurerm_resource_group.storage_accounts.location
  resource_group_name = azurerm_resource_group.storage_accounts.name
  subnet_id           = azurerm_subnet.plsubnet.id // private link subnet, in Databricks spoke VNet

  private_service_connection {
    name                           = "ple-dbfs-dfs-${var.prefix}-${var.env}-${var.suffix}"
    private_connection_resource_id = join("", [azurerm_databricks_workspace.this.managed_resource_group_id, "/providers/Microsoft.Storage/storageAccounts/${var.dbfsname}"])
    is_manual_connection           = false
    subresource_names              = ["dfs"]

    
  }

  private_dns_zone_group {
    name                 = "private-dns-zone-dbfs"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsdbfs_dfs.id]
  }
}
