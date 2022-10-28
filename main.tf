
terraform {
  backend "azurerm"{
    resource_group_name = "BOSS-RG"
    storage_account_name = "storage8096"
    container_name = "devstate"
    key = "terraform.devstate"
    access_key = "Ebs4MBe0rHMDkbW8lbfIAsEaNCk4Le+eB9FW9Tufg0F5dlR0r6NJHznbF3cGoXh7ksx9XGEch2Hk+AStN1fqZA=="
  }
}


provider "azurerm" {
    features {
      
    }
    subscription_id = var.subscription_id
    client_id = var.client_id
    tenant_id = var.tenant_id
    client_secret = var.client_secret

}

locals {
  setup_name = "IAC-RG"
}



resource "azurerm_resource_group" "RG1" {
    name = "BOSS-RG"
    location = "West Europe"
    tags =  {
     "name" = "IAC-RG"

    }
  
}

resource "azurerm_app_service_plan" "appplan1" {
    name = "appplandev"
    resource_group_name = azurerm_resource_group.RG1.name
    location = azurerm_resource_group.RG1.location
    sku {
      tier = "standard"
      size = "S1"

    }
    tags = {
      "name" = "practice-appplan"
    }
    depends_on = [
      azurerm_resource_group.RG1
    ]
}

resource "azurerm_app_service" "webapp1" {
    name = "webappdev8096"
    resource_group_name = azurerm_resource_group.RG1.name
    location = azurerm_resource_group.RG1.location
    app_service_plan_id = azurerm_app_service_plan.appplan1.id
    tags = {
      "name" = "practice-webapp"
    }
    depends_on = [
      azurerm_app_service_plan.appplan1
    ]
}


resource "azurerm_storage_account" "storageaccount1" {
  name                     = "storage8096"
  resource_group_name      = azurerm_resource_group.RG1.name
  location                 = azurerm_resource_group.RG1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "devstage"
  }
}
resource "azurerm_storage_container" "devstate1" {
  name = "devstate"
  storage_account_name = "storage8096"
  container_access_type = "container"

}