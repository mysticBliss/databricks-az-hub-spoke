locals {
  metastore_ips = toset(flatten([for k, v in data.dns_a_record_set.metastore : v.addrs]))
  eventhubs_ips = toset(flatten([for k, v in data.dns_a_record_set.eventhubs : v.addrs]))
  scc_relay_ips = toset(flatten([for k, v in data.dns_a_record_set.scc_relay : v.addrs]))
}

data "dns_a_record_set" "metastore" {
  for_each = toset(var.metastore)
  host     = each.value
}

data "dns_a_record_set" "eventhubs" {
  for_each = toset(var.eventhubs)
  host     = each.value
}

data "dns_a_record_set" "scc_relay" {
  for_each = toset(var.scc_relay)
  host     = each.value
}


resource "azurerm_firewall_network_rule_collection" "adbfnetwork" {
  name                = "adbcontrolplanenetwork"
  azure_firewall_name = var.hub_fw_name
  resource_group_name = var.hub_rg_name
  priority            = 200
  action              = "Allow"

  rule {
    name = "databricks-webapp"

    source_addresses = [
      join(", ", azurerm_subnet.public.address_prefixes),
      join(", ", azurerm_subnet.private.address_prefixes),
    ]

    destination_ports = [
      "443", "8443-8451",
    ]

    destination_addresses = var.webapp_ips

    protocols = [
      "TCP",
    ]
  }

  rule {
    name = "databricks-metastore"

    source_addresses = [
      join(", ", azurerm_subnet.public.address_prefixes),
      join(", ", azurerm_subnet.private.address_prefixes),
    ]

    destination_addresses = local.metastore_ips
    destination_ports     = ["3306"]
    protocols = [
      "TCP",
    ]
  }

  rule {
    name = "databricks-eventhubs"

    source_addresses = [
      join(", ", azurerm_subnet.public.address_prefixes),
      join(", ", azurerm_subnet.private.address_prefixes),
    ]

    destination_addresses = var.eventhubs
    destination_ports     = ["9093"]
    protocols = [
      "TCP",
    ]
  }

}

resource "azurerm_firewall_application_rule_collection" "adbfqdn" {
  name                = "adbcontrolplanefqdn"
  azure_firewall_name = var.hub_fw_name
  resource_group_name = var.hub_rg_name
  priority            = 200
  action              = "Allow"

  rule {
    name = "databricks-control-plane-services"

    source_addresses = [
      join(", ", azurerm_subnet.public.address_prefixes),
      join(", ", azurerm_subnet.private.address_prefixes),
    ]

    target_fqdns = var.firewallfqdn

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name = "databricks-dbfs"

    source_addresses = [
      join(", ", azurerm_subnet.public.address_prefixes),
      join(", ", azurerm_subnet.private.address_prefixes),
    ]

    target_fqdns = ["${var.dbfsname}.dfs.core.windows.net", "${var.dbfsname}.blob.core.windows.net"]

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name = "storage-accounts"

    source_addresses = [
      join(", ", azurerm_subnet.public.address_prefixes),
      join(", ", azurerm_subnet.private.address_prefixes),
    ]

    target_fqdns = ["${azurerm_storage_account.allowedstorage.name}.dfs.core.windows.net"]

    protocol {
      port = "443"
      type = "Https"
    }
  }

  dynamic "rule" {
    for_each = var.bypass_scc_relay ? [] : [1]
    content {
      name = "databricks-scc-relay"

      source_addresses = [
        join(", ", azurerm_subnet.public.address_prefixes),
        join(", ", azurerm_subnet.private.address_prefixes),
      ]

      target_fqdns = var.scc_relay

      protocol {
        port = "443"
        type = "Https"
      }
    }
  }
}




resource "azurerm_firewall_network_rule_collection" "allow_azuremonitor" {
  // allow access to Azure Monoring services
  name                = "allow_azuremonitor"
  azure_firewall_name = var.hub_fw_name
  resource_group_name = var.hub_rg_name
  priority            = 300
  action              = "Allow"

  rule {
    name                  = "allow_azuremonitor"
    source_addresses = [
      join(", ", azurerm_subnet.public.address_prefixes),
      join(", ", azurerm_subnet.private.address_prefixes),
    ]
    destination_ports     = ["*"]
    destination_addresses = ["AzureMonitor"]
    protocols             = ["Any"]
  }
}
