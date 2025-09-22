terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.45.0, < 5.0.0"
    }
  }
  required_version = ">= 1.8.2"
}
