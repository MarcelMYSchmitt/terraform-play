locals {
  acr_name = "${var.project_tag}${var.short_region}${var.env_tag}acr"
}

resource "azurerm_container_registry" "acr" {
  name                = local.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Premium"
  admin_enabled       = true
  tags = {
    "environment" = var.env_tag
    "project"     = var.project_tag
  }
}

resource "azurerm_key_vault_secret" "registry_secret" {
  name         = azurerm_container_registry.acr.admin_username
  value        = azurerm_container_registry.acr.admin_password
  key_vault_id = azurerm_key_vault.keyvault.id
}