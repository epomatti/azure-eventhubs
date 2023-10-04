terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.75.0"
    }
  }
}

### Locals ###

resource "random_integer" "affix" {
  min = 1000
  max = 9999
}

locals {
  project = "eventprocessor"
  affix   = "${local.project}-${random_integer.affix.result}"
}

### Group ###

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.project}"
  location = var.location
}

### Storage ###

resource "azurerm_storage_account" "default" {
  name                     = "stevhprocessor${random_integer.affix.result}"
  resource_group_name      = azurerm_resource_group.default.name
  location                 = azurerm_resource_group.default.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "events" {
  name                  = "events"
  storage_account_name  = azurerm_storage_account.default.name
  container_access_type = "private"
}

### Event Hub ###

resource "azurerm_eventhub_namespace" "default" {
  name                = "evhns-${local.affix}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = var.evh_sku
  capacity            = var.evh_capacity
}

resource "azurerm_eventhub" "default" {
  name                = "evh-${local.project}"
  namespace_name      = azurerm_eventhub_namespace.default.name
  resource_group_name = azurerm_resource_group.default.name
  partition_count     = var.evh_partition_count
  message_retention   = var.evh_message_retention

  capture_description {
    enabled             = true
    encoding            = "Avro"
    interval_in_seconds = var.evh_interval_in_seconds
    size_limit_in_bytes = var.evh_size_limit_in_bytes

    destination {
      name                = "EventHubArchive.AzureBlockBlob"
      blob_container_name = azurerm_storage_container.events.name
      storage_account_id  = azurerm_storage_account.default.id
      archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
    }
  }
}
