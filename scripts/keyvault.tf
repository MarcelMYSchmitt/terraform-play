locals {
  keyvault_name = "${var.project_tag}-${var.short_region}-${var.env_tag}-kv"
}

resource "azurerm_key_vault" "keyvault" {
  name                        = local.keyvault_name
  location                    = var.long_region
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  sku_name                    = "standard"

 access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    
    key_permissions = [
      "Get",
      "Create",
      "List"
    ]

    secret_permissions = [
      "Get",
      "Set",
      "List"
    ]

    storage_permissions = [
      "Get",
      "Set",
      "List"
    ]
  }

  tags = {
    "environment" = var.env_tag
    "project"     = var.project_tag
  }
}


resource "azurerm_key_vault_secret" "test_secret" {
  name         = "test-secret"
  value        = "secret-secret"
  key_vault_id = azurerm_key_vault.keyvault.id
}