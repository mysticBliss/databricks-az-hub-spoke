# Databricks Resource Group
resource "azurerm_resource_group" "rg_databricks" {
  name     = "rg-dbs-${var.prefix}-${var.env}-${var.suffix}"
  location = var.rglocation
}

resource "azurerm_databricks_workspace" "this" {
  name                                  = "workspace-${var.prefix}-${var.env}-${var.suffix}"
  resource_group_name                   = azurerm_resource_group.rg_databricks.name
  location                              = azurerm_resource_group.rg_databricks.location
  sku                                   = "premium"
  tags                                  = var.tags
  public_network_access_enabled         = false                    //use private endpoint
  network_security_group_rules_required = "NoAzureDatabricksRules" //use private endpoint
  customer_managed_key_enabled          = true
  //infrastructure_encryption_enabled = true
  managed_resource_group_name  = "databricks-managed-${var.prefix}-${var.env}-${var.suffix}"
  custom_parameters {
    no_public_ip                                         = true # Ensures no public IP is assigned to the workspace.
    virtual_network_id                                   = azurerm_virtual_network.this.id
    private_subnet_name                                  = azurerm_subnet.private.name
    public_subnet_name                                   = azurerm_subnet.public.name
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
    storage_account_name                                 = var.dbfsname #  Uses the local dbfsname variable for the Databricks File System (DBFS) storage account.
  }
  # We need this, otherwise destroy doesn't cleanup things correctly
  depends_on = [
    azurerm_subnet_network_security_group_association.public,
    azurerm_subnet_network_security_group_association.private
  ]
}
