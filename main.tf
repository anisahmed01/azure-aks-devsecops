
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "fc8c34a6-05b5-4c19-9943-052f1f2989bb"
}

resource "azurerm_resource_group" "aks_lab" {
  name     = "rg-aks-devsecops-lab"
  location = "Central India"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                      = "aks-devsecops-lab"
  location                  = azurerm_resource_group.aks_lab.location
  resource_group_name       = azurerm_resource_group.aks_lab.name
  dns_prefix                = "aks-devsecops-lab"
  sku_tier                  = "Free"
  automatic_upgrade_channel = "patch"

  default_node_pool {
    name       = "system"
    node_count = 1
    vm_size    = "Standard_D2s_v5"
    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}

output "resource_group_name" {
  value = azurerm_resource_group.aks_lab.name
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}
