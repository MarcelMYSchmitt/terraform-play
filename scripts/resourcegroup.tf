locals {
  resource_group_name = "${var.project_tag}-${var.short_region}-${var.env_tag}-rg"
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.long_region
  tags = {
    "evironment"  = var.env_tag
    "project"     = var.project_tag
  }
}