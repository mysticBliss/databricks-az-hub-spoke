# Azure Hub Module

## Introduction
The Azure Hub module is designed to create a secure hub for Azure resources, including an Azure Firewall and associated networking components. This module provisions necessary resources such as a resource group, public IP address, and firewall settings, allowing for secure communication between Azure services.

## Purpose
The module facilitates the deployment of an Azure Firewall within a custom virtual network, ensuring that resources are protected and that traffic can be controlled and logged.

## Usage
To use this module, include it in your Terraform configuration as follows:

```hcl
module "hub" {
  source = "./modules/hub"

  # Required variables
  workspace_prefix = "your_prefix"
  rglocation       = "your_location"
  tags             = {
    Owner = "your_name"
  }

  # Optional variables
  ...
}
```

### Step-by-Step Instructions
1. **Set Up Terraform**: Ensure you have Terraform installed and configured to work with your Azure account.
2. **Create a Terraform Configuration File**: Create a `.tf` file and include the module as shown above.
3. **Initialize Terraform**: Run `terraform init` to initialize the working directory containing the configuration files.
4. **Plan the Deployment**: Use `terraform plan` to see the resources that will be created.
5. **Apply the Configuration**: Run `terraform apply` to create the resources defined in the module.

## Resources Created
- Resource group for the hub
- Public IP address for the Azure Firewall
- Azure Firewall with network and application rules

## Local Variables
- **workspace_prefix**: A prefix for naming resources in the hub.
- **rglocation**: The location for the resource group.
- **tags**: A map of tags that are applied to all resources.
- **hubcidr**: The CIDR block for the hub VNet.

## Outputs
| Name | Description |
|------|-------------|
| [hubfirewall](#output_hubfirewall) | The name of the Azure Firewall. |
| [next_hop_in_ip_addresses](#output_next_hop_in_ip_addresses) | The private IP address used for routing traffic. |
| [hubvnet](#output_hubvnet) | The entire Hub Virtual Network object. |
<!-- BEGIN_TF_DOCS -->
## Requirements
No requirements.

## Providers

| Name | Version |
|------|---------|
| [azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) | n/a |

## Modules
No modules.

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| [workspace_prefix](#input_workspace_prefix) | Prefix for the workspace resources | `string` | n/a | yes |
| [rglocation](#input_rglocation) | Location for the resource group | `string` | n/a | yes |
| [tags](#input_tags) | Tags to apply to resources | `map(string)` | n/a | yes |
| [hubcidr](#input_hubcidr) | CIDR for Hub VNet | `string` | `"10.178.0.0/20"` | no |

## Passing tfvars
To define variable values, create a `terraform.tfvars` file in your project directory. This file should contain key-value pairs for the variables you want to set, for example:
```
workspace_prefix = "your_prefix"
rglocation = "your_location"
```

## Using Parallelism
You can control the number of concurrent operations in Terraform by using the `-parallelism` flag with commands like `terraform apply` or `terraform plan`. For example:
```
terraform apply -parallelism=10
```

## Generating Documentation
To generate documentation from your Terraform configurations, you can use tools like `terraform-docs`. Install it and run the following command in your project directory:
```
terraform-docs markdown . > README.md
```
This will generate a markdown file with documentation based on your Terraform files.
