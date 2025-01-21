# Main Terraform configuration for deploying the Hub module

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

module "hub" {
  source = "./modules/hub"

  workspace_prefix = var.workspace_prefix  # Prefix for the workspace resources
  rglocation       = var.rglocation        # Location for the resource group
  tags             = var.tags
  hubcidr          = var.hubcidr           # CIDR block for the hub network

}



module "spoke" {
  source = "./modules/spoke-workspace"

  workspace_prefix = var.workspace_prefix  # Prefix for the workspace resources
  rglocation       = var.rglocation        # Location for the resource group
  spokecidr       = var.spokecidr         # CIDR block for the spoke network
  tags            = var.tags

  metastore = var.metastore
  webapp_ips = var.webapp_ips
  firewallfqdn = var.firewallfqdn
  scc_relay = var.scc_relay
  eventhubs = var.eventhubs
  
 

  # Pass Objects from hub Module.
  hub_vnet_id         = module.hub.hubvnet.id    # Pass the entire hubvnet object to the spoke module
  hubfirewall  = module.hub.hubfirewall

  
}
