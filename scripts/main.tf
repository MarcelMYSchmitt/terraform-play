terraform {
  backend "azurerm" {
    container_name = "keystore"
    key            = "terraform.state"
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}

data "azurerm_client_config" "current" {}
