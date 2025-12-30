resource "azurerm_resource_group" "rg_foobar" {
  name     = "rg-${var.application_name}-${var.environment_name}"
  location = var.primary_region
}
