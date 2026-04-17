# Prompt for generating terraform definitinons

## Prompt: `sp-AzureInfra-plan` app registration + roles
Using the script below, do the following:
* create a new file named `sp.tf` 
* create an app registration named "sp-AzureInfra-plan2"
* add new variables in @terraform.tfvars:  subscription_Id="ad97ff06-f72c-496f-a08a-b07f4869a9ba"
* <subscription_id> refers in the script below refers to the subscription_id defined in @terraform.tfvars
* <BACKEND_RG> refers in the script below refers to the name of the resource group we have in @main.tf ( azurerm_storage_account.main.name)
* <STORAGE_ACCOUNT_NAME> refers in the script below refers to the name of the resource group we have in @main.tf ( azurerm_storage_account.main.name)

```
# Create the app registration sp-AzureInfra-plan
az ad app create --display-name "sp-AzureInfra-plan2" --query "{appId:appId, displayName:displayName, objectId:id}" -o json

# Create the service principal for the app registration
az ad sp create --id "215fa720-d01a-40e2-8178-396cb4012aa7" --query "{spObjectId:id, appId:appId, displayName:displayName}" -o json

# Reader at subscription level
az role assignment create \
  --assignee-object-id "a70ce07a-a02d-43de-8893-d46ef1d79737" \
  --assignee-principal-type ServicePrincipal \
  --role "Reader" \
  --scope "/subscriptions/<subscription_id>"

# Storage Blob Data Contributor on backend storage account
az role assignment create \
  --assignee-object-id "a70ce07a-a02d-43de-8893-d46ef1d79737" \
  --assignee-principal-type ServicePrincipal \
  --role "Storage Blob Data Contributor" \
  --scope "/subscriptions/<subscription_id>/resourceGroups/<BACKEND_RG>/providers/Microsoft.Storage/storageAccounts/<STORAGE_ACCOUNT_NAME>"
```

## Prompt: `sp-AzureInfra-plan` app registration's federated credentials
do the following:
* create a new file name `federated_credentials.tf`
* create 3 federated creadentials for the service principals "sp-AzureInfra-plan2" based on the following script:
* keep in mind that the id "2c063f29-a65c-4372-9f47-c0f26564a9c6" is object id of the service principal "sp-AzureInfra-plan2" that was previous created
```
# Add federated credential for branch main
az ad app federated-credential create \
  --id "2c063f29-a65c-4372-9f47-c0f26564a9c6" \
  --parameters '{"name":"github-branch-main","issuer":"https://token.actions.githubusercontent.com","subject":"repo:BigBroCode/terraform-01-azure-infra:ref:refs/heads/main","description":"GitHub Actions - push to main branch","audiences":["api://AzureADTokenExchange"]}' \
  --query "{name:name, subject:subject}" -o json

# Add federated credentials for environment plan
az ad app federated-credential create \
  --id "2c063f29-a65c-4372-9f47-c0f26564a9c6" \
  --parameters '{"name":"github-environment-plan","issuer":"https://token.actions.githubusercontent.com","subject":"repo:BigBroCode/terraform-01-azure-infra:environment:plan","description":"GitHub Actions - environment plan","audiences":["api://AzureADTokenExchange"]}' \
  --query "{name:name, subject:subject}" -o json 

# Add federated credentials for pull requests
az ad app federated-credential create \
  --id "2c063f29-a65c-4372-9f47-c0f26564a9c6" \
  --parameters '{"name":"github-pull-request","issuer":"https://token.actions.githubusercontent.com","subject":"repo:BigBroCode/terraform-01-azure-infra:pull_request","description":"GitHub Actions - pull requests","audiences":["api://AzureADTokenExchange"]}' \
  --query "{name:name, subject:subject}" -o json
```

## Prompt: `sp-AzureInfra-plan` app registration + roles
based on the script below, do the following:
* in the file @sp.tf, define a new app registration named "sp-AzureInfra-deploy" using the role assignments defined in the script below
* in the file @federated_credentials.tf, define the federated credentials the will be the same as in the one defined in the script below
* create a variable in @terraform.tfvars named tenant_id="a95a14c9-e700-4ad4-a021-5bde0ed70d8d" and refer to it when needed in the @sp.tf and @federated_credentials.tf


```sh
# Create the app registration sp-AzureInfra-deploy
az ad app create --display-name "sp-AzureInfra-deploy" --query "{appId:appId, objectId:id, displayName:displayName}" -o json
# App created. client_id = 9e807e54-45eb-44bb-aa79-18e2b6b9e8ea, object_id = 4bf35873-1709-4dae-a5cb-6bd33afada10.

# Create service principal for the registered app
az ad sp create --id "9e807e54-45eb-44bb-aa79-18e2b6b9e8ea" --query "{id:id, appId:appId, displayName:displayName}" -o json

# Assign Owner role assignment at tenant root management group
az role assignment create \
  --role "Owner" \
  --assignee "9e807e54-45eb-44bb-aa79-18e2b6b9e8ea" \
  --scope "/providers/Microsoft.Management/managementGroups/a95a14c9-e700-4ad4-a021-5bde0ed70d8d" \
  --query "{roleDefinitionName:roleDefinitionName, principalName:principalName, scope:scope}" -o json 

# Add federated credential for branch main (1st federation)
az ad app federated-credential create \
  --id "4bf35873-1709-4dae-a5cb-6bd33afada10" \
  --parameters '{"name":"github-branch-main","issuer":"https://token.actions.githubusercontent.com","subject":"repo:BigBroCode/terraform-01-azure-infra:ref:refs/heads/main","description":"GitHub Actions - push to main branch","audiences":["api://AzureADTokenExchange"]}' \
  --query "{name:name, subject:subject, issuer:issuer}" -o json

# Add federated credential for environment deploy (2nd federation)
az ad app federated-credential create \
  --id "4bf35873-1709-4dae-a5cb-6bd33afada10" \
  --parameters '{"name":"github-environment-deploy","issuer":"https://token.actions.githubusercontent.com","subject":"repo:BigBroCode/terraform-01-azure-infra:environment:deploy","description":"GitHub Actions - environment deploy","audiences":["api://AzureADTokenExchange"]}' \
  --query "{name:name, subject:subject, issuer:issuer}" -o json

# Add federated credential for pull requests (3rd federation)
az ad app federated-credential create \
  --id "4bf35873-1709-4dae-a5cb-6bd33afada10" \
  --parameters '{"name":"github-pull-request","issuer":"https://token.actions.githubusercontent.com","subject":"repo:BigBroCode/terraform-01-azure-infra:pull_request","description":"GitHub Actions - pull requests","audiences":["api://AzureADTokenExchange"]}' \
  --query "{name:name, subject:subject, issuer:issuer}" -o json
```