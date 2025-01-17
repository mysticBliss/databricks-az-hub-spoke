variable "workspace_prefix" {
  type        = string
  description = "Prefix for the workspace resources"
}

variable "rglocation" {
  type        = string
  description = "Location for the resource group"
}

variable "spokecidr" {
  type        = string
  default     = "10.179.0.0/20"
  description = "CIDR for Spoke VNet"
}
variable "tags" {
  type        = map(any)
  description = "Tags to apply to resources"
}

variable "hubcidr" {
  type        = string
  default     = "10.178.0.0/20"
  description = "CIDR for Hub VNet"
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID of Azure"
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
  type        = list(any)
  description = "Additional list of fully qualified domain names to add to firewall rules"
}
