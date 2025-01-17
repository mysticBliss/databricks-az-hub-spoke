# This Terraform configuration sets up an Azure Firewall with a public IP address.
# The Azure Firewall is a cloud-native network security service that protects Azure Virtual Network resources.
# It allows you to control and log traffic to and from your Azure resources.

resource "azurerm_public_ip" "fwpublicip" {
  # This block defines a public IP address resource for the Azure Firewall.
  # A public IP address is required for the firewall to communicate with the internet.
  name                = "hubfirewallpublicip"  # Name of the public IP resource
  location            = azurerm_resource_group.this.location  # Location of the resource
  resource_group_name = azurerm_resource_group.this.name  # Resource group where the IP is created
  allocation_method   = "Static"  # Specifies that the IP address will not change
  sku                 = "Standard"  # Standard SKU for the public IP, suitable for production use
}

resource "azurerm_firewall" "hubfw" {
  # This block defines the Azure Firewall resource.
  # The firewall acts as a security barrier between your Azure resources and the internet.
  name                = "hubfirewall"  # Name of the Azure Firewall resource
  location            = azurerm_resource_group.this.location  # Location of the firewall
  resource_group_name = azurerm_resource_group.this.name  # Resource group where the firewall is created
  sku_name            = "AZFW_VNet"  # SKU name for the Azure Firewall, indicating it's for Virtual Networks
  sku_tier            = "Standard"    # SKU tier for the firewall, providing advanced features

  ip_configuration {
    # This block configures the IP settings for the Azure Firewall.
    name                 = "configuration"  # Name of the IP configuration
    subnet_id            = azurerm_subnet.hubfw.id  # Subnet where the firewall is deployed
    public_ip_address_id = azurerm_public_ip.fwpublicip.id  # Reference to the public IP address created above
  }
}

# Uncomment and configure the following sections as needed for network and application rules

# resource "azurerm_firewall_network_rule_collection" "adbfnetwork" {
#   # This block defines a collection of network rules for the Azure Firewall.
#   # Network rules allow or deny traffic based on source IP addresses, destination ports, and protocols.

#   name                = "adbcontrolplanenetwork"
#   azure_firewall_name = azurerm_firewall.hubfw.name
#   resource_group_name = azurerm_resource_group.this.name
#   priority            = 200  # Priority of the rule collection, lower numbers are processed first
#   action              = "Allow"  

#   rule {
#     name = "databricks-metastore"  

#     source_addresses = [
#       join(", ", azurerm_subnet.public.address_prefixes),  # Allowed source IP addresses
#       join(", ", azurerm_subnet.private.address_prefixes),
#     ]

#     destination_ports = [
#       "3306",  # Port for MySQL database connections
#     ]

#     destination_addresses = [
#       var.metastore != "" ? var.metastore : null  # Optional destination IP addresses
#     ]

#     protocols = [
#       "TCP",  # Protocol for the rule
#     ]
#   }
# }

# resource "azurerm_firewall_application_rule_collection" "adbfqdn" {
#   This block defines a collection of application rules for the Azure Firewall.
#   Application rules allow or deny traffic based on fully qualified domain names (FQDNs).
#   name                = "adbcontrolplanefqdn"
#   azure_firewall_name = azurerm_firewall.hubfw.name
#   resource_group_name = azurerm_resource_group.this.name
#   priority            = 200  # Priority of the rule collection
#   action              = "Allow"  # Action to take (Allow or Deny)

#   rule {
#     name = "databricks-control-plane-services"  # Name of the individual rule

#     source_addresses = [
#       join(", ", azurerm_subnet.public.address_prefixes),  # Allowed source IP addresses
#       join(", ", azurerm_subnet.private.address_prefixes),
#     ]

#     # target_fqdns = var.firewallfqdn  # Optional target FQDNs

#     protocol {
#       port = "443"  # Port for HTTPS traffic
#       type = "Https"  # Protocol type
#     }
#   }
# }



