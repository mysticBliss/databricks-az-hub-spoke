# Virtual Machines Resource Group
resource "azurerm_resource_group" "rg_vm" {
  name     = "rg-vitual-machine-${var.prefix}-${var.env}-${var.suffix}"
  location = var.rglocation
}

resource "azurerm_network_interface" "testvmnic" {
  name                = "nic-vitual-machine-${var.prefix}-${var.env}-${var.suffix}"
  location            = azurerm_resource_group.rg_vm.location
  resource_group_name = azurerm_resource_group.rg_vm.name

  ip_configuration {
    name                          = "vm-public-ip"
    subnet_id                     = azurerm_subnet.testvmsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.testvmpublicip.id
  }
}

resource "azurerm_network_security_group" "testvm-nsg" {
  name                = "nsg-vitual-machine-${var.prefix}-${var.env}-${var.suffix}"
  location            = azurerm_resource_group.rg_vm.location
  resource_group_name = azurerm_resource_group.rg_vm.name
  tags                = var.tags
}

resource "azurerm_network_interface_security_group_association" "testvmnsgassoc" {
  network_interface_id      = azurerm_network_interface.testvmnic.id
  network_security_group_id = azurerm_network_security_group.testvm-nsg.id
}

data "http" "my_public_ip" { // add your host machine ip into nsg

  url = "https://ifconfig.co/json"
  request_headers = {
    Accept = "application/json"
  }
}

locals {
  ifconfig_co_json = jsondecode(data.http.my_public_ip.response_body)
}

resource "azurerm_network_security_rule" "test0" {
  name                        = "RDP"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefixes     = [local.ifconfig_co_json.ip]
  destination_address_prefix  = "VirtualNetwork"
  network_security_group_name = azurerm_network_security_group.testvm-nsg.name
  resource_group_name         = azurerm_resource_group.rg_vm.name
}

// give a public ip addr to vm
resource "azurerm_public_ip" "testvmpublicip" {
  name                = "pip-vitual-machine-${var.prefix}-${var.env}-${var.suffix}"
  location            = azurerm_resource_group.rg_vm.location
  resource_group_name = azurerm_resource_group.rg_vm.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_windows_virtual_machine" "testvm" {
  name                = "vm-vitual-machine-${var.prefix}-${var.env}-${var.suffix}"
  resource_group_name = azurerm_resource_group.rg_vm.name
  location            = azurerm_resource_group.rg_vm.location
  size                = "Standard_F4s_v2"
  admin_username      = "azureuser"
  admin_password      = var.test_vm_password
  network_interface_ids = [
    azurerm_network_interface.testvmnic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-10"
    sku       = "19h2-pro-g2"
    version   = "latest"
  }
}

resource "azurerm_subnet" "testvmsubnet" {
  name                 = "snet-vitual-machine-${var.prefix}-${var.env}-${var.suffix}"
  resource_group_name  = azurerm_resource_group.rg_vm.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.spokecidr, 3, 3)]
}
