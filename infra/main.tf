terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.24.0"
    }
  }
  backend "local" {
    path = ".workspace/terraform.tfstate"
  }
}

provider "azurerm" {
  features {
  }
}

### Locals ###

locals {
  project = "eventprocessor-${random_integer.affix.result}"
}

resource "random_integer" "affix" {
  min = 1000
  max = 9999
}

### Group ###

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.project}-"
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
  name                = "evhns-${local.project}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = var.sku
  capacity            = var.capacity
}

resource "azurerm_eventhub" "default" {
  name                = "evh-${local.project}"
  namespace_name      = azurerm_eventhub_namespace.default.name
  resource_group_name = azurerm_resource_group.default.name
  partition_count     = var.partition_count
  message_retention   = var.message_retention

  capture_description {
    enabled             = true
    encoding            = "Avro"
    interval_in_seconds = var.interval_in_seconds
    size_limit_in_bytes = var.size_limit_in_bytes

    destination {
      name                = "EventHubArchive.AzureBlockBlob"
      blob_container_name = azurerm_storage_container.events.name
      storage_account_id  = azurerm_storage_account.default.id
      archive_name_format = "{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}"
    }
  }
}


