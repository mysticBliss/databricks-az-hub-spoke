output "hubfirewall" {
  # This output provides the name of the Azure Firewall.
  value = azurerm_firewall.hubfw.name
}


output "next_hop_in_ip_addresses" {
  value = "Firewall traffic forwarded to: ${azurerm_firewall.hubfw.ip_configuration[0].private_ip_address}"
}

output "hubvnet" {
  # This output provides the entire Hub Virtual Network object.
  value = azurerm_virtual_network.hubvnet.name
}


output "rg_name" {
  value = azurerm_resource_group.this.name
}
