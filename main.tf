resource "azurerm_resource_group" "rg_foobar" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.primary_region
}

resource "random_string" "suffix" {
  length  = 10
  upper   = false
  special = false

}


resource "azurerm_storage_account" "sa_foobar" {
  name                     = "st${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg_foobar.name
  location                 = azurerm_resource_group.rg_foobar.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}
