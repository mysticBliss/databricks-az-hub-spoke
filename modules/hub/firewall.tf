# This Terraform configuration sets up an Azure Firewall with a public IP address.
# The Azure Firewall is a cloud-native network security service that protects Azure Virtual Network resources.
# It allows you to control and log traffic to and from your Azure resources.

resource "azurerm_public_ip" "fwpublicip" {
  # This block defines a public IP address resource for the Azure Firewall.
  # A public IP address is required for the firewall to communicate with the internet.
  name                = "pip-${local.prefix}-${local.env}-${local.suffix}"  # Name of the public IP resource
  location            = azurerm_resource_group.this.location  # Location of the resource
  resource_group_name = azurerm_resource_group.this.name  # Resource group where the IP is created
  allocation_method   = "Static"  # Specifies that the IP address will not change
  sku                 = "Standard"  # Standard SKU for the public IP, suitable for production use
}

resource "azurerm_firewall" "hubfw" {
  # This block defines the Azure Firewall resource.
  # The firewall acts as a security barrier between your Azure resources and the internet.
  name                = "fw-${local.prefix}-${local.env}-${local.suffix}"  # Name of the Azure Firewall resource
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


