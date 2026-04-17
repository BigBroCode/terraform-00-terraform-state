terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.57.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.8"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.8"
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
  subscription_id = var.subscription_id
}

provider "azuread" {}

