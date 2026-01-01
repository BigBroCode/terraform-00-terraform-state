# Setting `hashicorp/azurerm`

This is how to define a provide named `azurerm` using `hashicorp/azurerm`
**solution 1**

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.57.0"
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
  subscription_id = "ad97ff06-f72c-496f-a08a-b07f4869a9ba"
}
```

**solution 2**
We could also define as follows using environment variable.

```ps
$env:ARM_SUBSCRIPTION_ID="ad97ff06-f72c-496f-a08a-b07f4869a9ba"
```

```sh
export ARM_SUBSCRIPTION_ID="ad97ff06-f72c-496f-a08a-b07f4869a9ba"
```

and consequently, the `azurerm` provider will defined as follows:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.57.0"
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
  # no more subscription_id to define here.
}
```
