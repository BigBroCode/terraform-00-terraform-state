resource "azuread_application_federated_identity_credential" "github_branch_main" {
  application_id = azuread_application.sp_azure_infra_plan.id
  display_name   = "github-branch-main"
  description    = "GitHub Actions - push to main branch"
  issuer         = var.github_issuer
  subject        = "${var.github_repo}:ref:refs/heads/main"
  audiences      = [var.github_audience]
}

resource "azuread_application_federated_identity_credential" "github_environment_plan" {
  application_id = azuread_application.sp_azure_infra_plan.id
  display_name   = "github-environment-plan"
  description    = "GitHub Actions - environment plan"
  issuer         = var.github_issuer
  subject        = "${var.github_repo}:environment:plan"
  audiences      = [var.github_audience]
}

resource "azuread_application_federated_identity_credential" "github_pull_request" {
  application_id = azuread_application.sp_azure_infra_plan.id
  display_name   = "github-pull-request"
  description    = "GitHub Actions - pull requests"
  issuer         = var.github_issuer
  subject        = "${var.github_repo}:pull_request"
  audiences      = [var.github_audience]
}

resource "azuread_application_federated_identity_credential" "deploy_github_branch_main" {
  application_id = azuread_application.sp_azure_infra_deploy.id
  display_name   = "github-branch-main"
  description    = "GitHub Actions - push to main branch"
  issuer         = var.github_issuer
  subject        = "${var.github_repo}:ref:refs/heads/main"
  audiences      = [var.github_audience]
}

resource "azuread_application_federated_identity_credential" "deploy_github_environment_deploy" {
  application_id = azuread_application.sp_azure_infra_deploy.id
  display_name   = "github-environment-deploy"
  description    = "GitHub Actions - environment deploy"
  issuer         = var.github_issuer
  subject        = "${var.github_repo}:environment:deploy"
  audiences      = [var.github_audience]
}

resource "azuread_application_federated_identity_credential" "deploy_github_pull_request" {
  application_id = azuread_application.sp_azure_infra_deploy.id
  display_name   = "github-pull-request"
  description    = "GitHub Actions - pull requests"
  issuer         = var.github_issuer
  subject        = "${var.github_repo}:pull_request"
  audiences      = [var.github_audience]
}
