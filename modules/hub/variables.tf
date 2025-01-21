
variable "prefix" {
  description = "The prefix for resource names."
  type        = string
}

variable "env" {
  description = "The environment (e.g., dev, prod)."
  type        = string
}

variable "suffix" {
  description = "The suffix for resource names."
  type        = string
}

variable "rglocation" {
  description = "The location where the resource group will be created."
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default = {
    createdByTerraform = "True"
  }
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




