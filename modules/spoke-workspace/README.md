# Azure Databricks Workspace Module

## Introduction
Azure Databricks is a fast, easy, and collaborative Apache Spark-based analytics platform optimized for Azure. This module allows you to create an Azure Databricks workspace within a custom virtual network (VNet), ensuring secure access and integration with other Azure services.

This module provisions necessary resources such as a resource group, virtual network, subnets, and the Databricks workspace itself, allowing for a secure and scalable deployment.

## Purpose
The module is designed to facilitate the deployment of Azure Databricks workspaces in a secure manner, allowing for integration with other Azure services while maintaining network isolation.

## Usage
To use this module, include it in your Terraform configuration as follows:

```hcl
module "spoke_workspace" {
  source = "./modules/spoke-workspace"

  # Required variables
  metastore = ["<metastore_fqdn>"]
  eventhubs = ["<eventhub_fqdn>"]
  scc_relay = ["<scc_relay_fqdn>"]
  webapp_ips = ["<webapp_ip_ranges>"]

  # Optional variables
  rglocation = "uksouth"
  ...
}
```

### Step-by-Step Instructions
1. **Set Up Terraform**: Ensure you have Terraform installed and configured to work with your Azure account.
2. **Create a Terraform Configuration File**: Create a `.tf` file and include the module as shown above.
3. **Initialize Terraform**: Run `terraform init` to initialize the working directory containing the configuration files.
4. **Plan the Deployment**: Use `terraform plan` to see the resources that will be created.
5. **Apply the Configuration**: Run `terraform apply` to create the resources defined in the module.

## Common Use Cases
- **Data Engineering**: Use this module to set up a Databricks workspace for data processing and analytics.
- **Machine Learning**: Deploy a secure environment for building and training machine learning models.
- **Collaborative Analytics**: Enable teams to collaborate on data analysis projects in a secure environment.

## Troubleshooting Tips
- **Issue: Terraform Fails to Create Resources**: Ensure that your Azure account has the necessary permissions to create resources in the specified resource group.
- **Issue: Network Connectivity Problems**: Verify that the virtual network and subnets are correctly configured and that the necessary firewall rules are in place.

## Resources Created
- Resource group with a random prefix
- Tags, including `Owner`, which is taken from `az account show --query user`
- VNet with public and private subnets
- Databricks workspace

## Local Variables
- **prefix**: A unique prefix for naming resources, generated using a random string.
- **location**: The location for the resource group, defined by the variable `rglocation`.
- **cidr**: The CIDR block for the spoke VNet, defined by the variable `spokecidr`.
- **dbfsname**: The name for the DBFS storage account, generated using a random string.
- **tags**: A map of tags that are applied to all resources, including the owner and epoch.
<!-- BEGIN_TF_DOCS -->
## Requirements
No requirements.

## Providers

| Name | Version |
|------|---------|
| [azurerm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) | n/a |
| [dns](https://registry.terraform.io/providers/hashicorp/dns/latest/docs) | n/a |
| [external](https://registry.terraform.io/providers/hashicorp/external/latest/docs) | n/a |
| [http](https://registry.terraform.io/providers/hashicorp/http/latest/docs) | n/a |
| [random](https://registry.terraform.io/providers/hashicorp/random/latest/docs) | n/a |

## Modules
No modules.

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| [bypass_scc_relay](#input_bypass_scc_relay) | If we should bypass firewall for Secure Cluster Connectivity traffic or not | `bool` | `true` | no |
| [dbfs_prefix](#input_dbfs_prefix) | Prefix for DBFS storage account name | `string` | `"dbfs"` | no |
| [eventhubs](#input_eventhubs) | List of FQDNs for Azure Databricks EventHubs traffic | `list(string)` | n/a | yes |
| [firewallfqdn](#input_firewallfqdn) | List of domains names to put into application rules for handling of HTTPS traffic | `list(string)` | n/a | yes |
| [hubfirewall](#input_hubfirewall) | Firewall from the Hub Module | `any` | n/a | yes |
| [hubvnet](#input_hubvnet) | The entire hub virtual network object. | <pre>object({<br>    id                = string<br>    name              = string<br>    location          = string<br>    resource_group_name = string<br>    address_space      = list(string)<br>    tags              = map(string)<br>  })</pre> | n/a | yes |
| [metastore](#input_metastore) | List of FQDNs for Azure Databricks Metastore databases | `list(string)` | n/a | yes |
| [private_subnet_endpoints](#input_private_subnet_endpoints) | The list of Service endpoints to associate with the private subnet. | `list(string)` | `[]` | no |
| [rglocation](#input_rglocation) | Location of resource group to create | `string` | `"uksouth"` | no |
| [scc_relay](#input_scc_relay) | List of FQDNs for Azure Databricks Secure Cluster Connectivity relay | `list(string)` | n/a | yes |
| [spokecidr](#input_spokecidr) | CIDR for Spoke VNet | `string` | `"10.179.0.0/20"` | no |
| [tags](#input_tags) | map of tags to add to all resources | `map(any)` | `{}` | no |
| [test_vm_password](#input_test_vm_password) | Password for Test VM | `string` | `"TesTed567!!!"` | no |
| [webapp_ips](#input_webapp_ips) | List of IP ranges for Azure Databricks Webapp | `list(string)` | n/a | yes |
| [workspace_prefix](#input_workspace_prefix) | Prefix to use for Workspace name | `string` | `"adb"` | no |

## Outputs
| Name | Description |
|------|-------------|
| [databricks_azure_workspace_resource_id](#output_databricks_azure_workspace_resource_id) | The ID of the Databricks Workspace in the Azure management plane. |
| [my_ip_addr](#output_my_ip_addr) | IP address of caller |
| [test_vm_public_ip](#output_test_vm_public_ip) | Public IP of the created virtual machine |
| [workspace_url](#output_workspace_url) | The workspace URL which is of the format 'adb-{workspaceId}.{random}.azuredatabricks.net' |

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
