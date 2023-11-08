
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.79.0"
    }
  }
}


provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
  }
}



resource "azurerm_resource_group" "rg_backend" {
  name     = var.rg_name_backend
  location = var.rg_backend_location
}


resource "azurerm_storage_account" "az_sa_backend" {
  name                     ="${lower(var.az_sa_name)}${random_string.random_string.result}" 
  resource_group_name      = azurerm_resource_group.rg_backend.name
  location                 = azurerm_resource_group.rg_backend.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  
}

resource "azurerm_storage_container" "az_sc_backend" {
  name                  = var.az_sc_backend_name
  storage_account_name  = azurerm_storage_account.az_sc_backend.name
  container_access_type = "private"
}

data "azurerm_client_config" "current" {}

resource "random_string" "random_test" {
  length = 16
  upper  = false
  special = false 
}


resource "azurerm_key_vault" "key_vault_backend" {
  name                        = var.sa_backend_accesskey_name
  location                    = azurerm_resource_group.rg_backend.location
  resource_group_name         = azurerm_resource_group.rg_backend.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "Set", "Create"
    ]

    secret_permissions = [
      "Get","Set", "List",
    ]

    storage_permissions = [
      "Get","Set", "List",
    ]
  }
}

resource "azurerm_key_vault_secret" "az_sa_backend_accesskey" {
  name         = var.sa_backend_accesskey_name
  value        = azurerm_storage_account.az_sa_backend_accesskey.primary_access_key
  key_vault_id = azurerm_key_vault.key_vault_backend.id
}