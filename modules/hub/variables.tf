variable "workspace_prefix" {
  type        = string
  description = "Prefix for the workspace resources"
}

variable "rglocation" {
  type        = string
  description = "Location for the resource group"
}



variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

variable "hubcidr" {
  type        = string
  default     = "10.178.0.0/20"
  description = "CIDR for Hub VNet"
}