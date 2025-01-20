<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

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
<!-- BEGIN_TF_DOCS -->
## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_hub"></a> [hub](#module\_hub) | ./modules/hub | n/a |
| <a name="module_spoke"></a> [spoke](#module\_spoke) | ./modules/spoke-workspace | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bypass_scc_relay"></a> [bypass\_scc\_relay](#input\_bypass\_scc\_relay) | If we should bypass firewall for Secure Cluster Connectivity traffic or not | `bool` | `true` | no |
| <a name="input_eventhubs"></a> [eventhubs](#input\_eventhubs) | List of FQDNs for Azure Databricks EventHubs traffic | `list(string)` | n/a | yes |
| <a name="input_firewallfqdn"></a> [firewallfqdn](#input\_firewallfqdn) | Additional list of fully qualified domain names to add to firewall rules | `list(any)` | n/a | yes |
| <a name="input_hubcidr"></a> [hubcidr](#input\_hubcidr) | CIDR for Hub VNet | `string` | `"10.178.0.0/20"` | no |
| <a name="input_metastore"></a> [metastore](#input\_metastore) | List of FQDNs for Azure Databricks Metastore databases | `list(string)` | n/a | yes |
| <a name="input_rglocation"></a> [rglocation](#input\_rglocation) | Location for the resource group | `string` | n/a | yes |
| <a name="input_scc_relay"></a> [scc\_relay](#input\_scc\_relay) | List of FQDNs for Azure Databricks Secure Cluster Connectivity relay | `list(string)` | n/a | yes |
| <a name="input_spokecidr"></a> [spokecidr](#input\_spokecidr) | CIDR for Spoke VNet | `string` | `"10.179.0.0/20"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Subscription ID of Azure | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(any)` | n/a | yes |
| <a name="input_webapp_ips"></a> [webapp\_ips](#input\_webapp\_ips) | List of IP ranges for Azure Databricks Webapp | `list(string)` | n/a | yes |
| <a name="input_workspace_prefix"></a> [workspace\_prefix](#input\_workspace\_prefix) | Prefix for the workspace resources | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
