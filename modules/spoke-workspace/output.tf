output "my_ip_addr" {
  value       = local.ifconfig_co_json.ip
  description = "IP address of caller"
}

output "test_vm_public_ip" {
  value       = azurerm_public_ip.testvmpublicip.ip_address
  description = "Public IP of the created virtual machine"
}

output "databricks_azure_workspace_resource_id" {
  description = "The ID of the Databricks Workspace in the Azure management plane."
  value       = azurerm_databricks_workspace.this.id
}

output "workspace_url" {
  value       = "https://${azurerm_databricks_workspace.this.workspace_url}/"
  description = "The workspace URL which is of the format 'adb-{workspaceId}.{random}.azuredatabricks.net'"
}
