# output "hubfwpublicip" {
#   # This output provides the public IP address of the Azure Firewall.
#   value = azurerm_public_ip.fwpublicip
# }

output "hubfirewall" {
  # This output provides the name of the Azure Firewall.
  value = azurerm_firewall.hubfw
}

# output "hub_rg" {
#   # This output provides the name of Hub Resource Group
#   value = azurerm_resource_group.this.name
# }

output "next_hop_in_ip_addresses" {
  value = "Firewall traffic forwarded to: ${azurerm_firewall.hubfw.ip_configuration[0].private_ip_address}"
}

output "hubvnet" {
  # This output provides the entire Hub Virtual Network object.
  value = azurerm_virtual_network.hubvnet
}

# output "firewall_private_ip" {
#   # This output provides the private IP address of the Azure Firewall.
#   value = azurerm_firewall.hubfw.ip_configuration[0].private_ip_address
# }
