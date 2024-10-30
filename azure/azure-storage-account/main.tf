provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "example" {
  name     = "trinidad-resources"
  location = "East US"
}

# Storage Account for Terraform State
resource "azurerm_storage_account" "example" {
  name                     = "trinidadstorageacct"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Blob Container for Terraform State
resource "azurerm_storage_container" "example" {
  name                  = "terraform-state"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

output "storage_account_name" {
  value = azurerm_storage_account.example.name
}

# Configure the Terraform backend to use this Azure Blob Storage
# When initializing the first time comment this
terraform {
  backend "azurerm" {
    storage_account_name = "trinidadstorageacct"
    container_name       = "terraform-state"
    key                  = "azure-storage-account/terraform.tfstate"
    resource_group_name  = "trinidad-resources"
  }
}
