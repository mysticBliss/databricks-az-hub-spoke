# Storage Accounts Resource Group
resource "azurerm_resource_group" "storage_accounts" {
  name     = "rg-sa-${var.prefix}-${var.env}-${var.suffix}"
  location = var.rglocation
}


resource "azurerm_storage_account" "allowedstorage" {
  name                = "sa${var.prefix}${var.env}${var.suffix}"
  resource_group_name = azurerm_resource_group.storage_accounts.name
  location                 = azurerm_resource_group.storage_accounts.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled           = true
  tags                     = var.tags
}
