resource "azuread_application" "sp_azure_infra_plan" {
  display_name = "sp-AzureInfra-plan"
}

resource "azuread_service_principal" "sp_azure_infra_plan" {
  client_id = azuread_application.sp_azure_infra_plan.client_id
}

resource "azurerm_role_assignment" "sp_reader_subscription" {
  principal_id         = azuread_service_principal.sp_azure_infra_plan.object_id
  principal_type       = "ServicePrincipal"
  role_definition_name = "Reader"
  scope                = "/subscriptions/${var.subscription_id}"
}

resource "azurerm_role_assignment" "sp_plan_storage_account_contributor" {
  principal_id         = azuread_service_principal.sp_azure_infra_plan.object_id
  principal_type       = "ServicePrincipal"
  role_definition_name = "Storage Account Contributor"
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${azurerm_resource_group.main.name}/providers/Microsoft.Storage/storageAccounts/${azurerm_storage_account.main.name}"
}

resource "azuread_application" "sp_azure_infra_deploy" {
  display_name = "sp-AzureInfra-deploy"
}

resource "azuread_service_principal" "sp_azure_infra_deploy" {
  client_id = azuread_application.sp_azure_infra_deploy.client_id
}

resource "azurerm_role_assignment" "sp_deploy_owner_tenant_root" {
  principal_id         = azuread_service_principal.sp_azure_infra_deploy.object_id
  principal_type       = "ServicePrincipal"
  role_definition_name = "Owner"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.tenant_id}"
}
