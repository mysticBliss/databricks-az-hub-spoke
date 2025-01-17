variable "spokecidr" {
  type        = string
  default     = "10.179.0.0/20"
  description = "CIDR for Spoke VNet"
}

variable "rglocation" {
  type        = string
  default     = "uksouth"
  description = "Location of resource group to create"
}

variable "metastore" {
  description = "List of FQDNs for Azure Databricks Metastore databases"
  type        = list(string)
}

variable "scc_relay" {
  description = "List of FQDNs for Azure Databricks Secure Cluster Connectivity relay"
  type        = list(string)
}

variable "webapp_ips" {
  description = "List of IP ranges for Azure Databricks Webapp"
  type        = list(string)
}

variable "eventhubs" {
  description = "List of FQDNs for Azure Databricks EventHubs traffic"
  type        = list(string)
}

variable "bypass_scc_relay" {
  description = "If we should bypass firewall for Secure Cluster Connectivity traffic or not"
  type        = bool
  default     = true
}

variable "firewallfqdn" {
  type        = list(string)
  description = "List of domains names to put into application rules for handling of HTTPS traffic (Databricks storage accounts, etc.)"
}

variable "dbfs_prefix" {
  type        = string
  default     = "dbfs"
  description = "Prefix for DBFS storage account name"
}

variable "workspace_prefix" {
  type        = string
  default     = "adb"
  description = "Prefix to use for Workspace name"
}

variable "test_vm_password" {
  type        = string
  default     = "TesTed567!!!"
  description = "Password for Test VM"
}

variable "private_subnet_endpoints" {
  description = "The list of Service endpoints to associate with the private subnet."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "map of tags to add to all resources"
  type        = map(any)
  default     = {}
}

variable "hubvnet" {
  description = "The entire hub virtual network object."
  type = object({
    id                = string
    name              = string
    location          = string
    resource_group_name = string
    address_space      = list(string)
    tags              = map(string)
  })
}


# variable "hubvnet" {
#   type = any
# }

variable "hubfirewall" {
  type = any
}
