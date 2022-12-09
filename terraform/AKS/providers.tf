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

  subscription_id = var.subscription_id
}


terraform {
  backend "azurerm" {
    resource_group_name  = "DevOps-GL5"
    storage_account_name = "devopsterraz"
    container_name       = "devops-gl5"
    key                  = "aks/terraform.tfstate"
  }
}

provider "kubernetes" {
  config_path = var.kube_config_path
}

provider "helm" {
  kubernetes {
    config_path = var.kube_config_path
  }
}
