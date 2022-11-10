terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}
provider "azurerm" {
  features {}

  subscription_id = "2bfd66e2-d8f3-4fa4-b3d2-a0e7bc2d39a0"
}