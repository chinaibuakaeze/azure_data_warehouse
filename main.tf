terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}

}

# Create resource group
resource "azurerm_resource_group" "dataeng" {
  name     = "dataeng"
  location = "southcentralus"
}

 # Create azure postgres sql server
resource "azurerm_postgresql_flexible_server" "bikedata" {
  name                   = "bikedata"
  resource_group_name    = azurerm_resource_group.dataeng.name
  location               = azurerm_resource_group.dataeng.location
  version                = "13"
  administrator_login    = "china"
  administrator_password = "bebe1234!"
  zone              =  "3"
  storage_mb = 32768
  sku_name   = "B_Standard_B1ms"
}

# Create azure firewall rules for postgres sql server
resource "azurerm_postgresql_flexible_server_firewall_rule" "AllowAll" {
  name                = "AllowAll"
  server_id           = azurerm_postgresql_flexible_server.bikedata.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}
# Create azure storage account
resource "azurerm_storage_account" "bikedatastc" {
  name                     = "bikedatastc"
  resource_group_name      = azurerm_resource_group.dataeng.name
  location                 = azurerm_resource_group.dataeng.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"

}

# Create azure datalake gen 2 filesystem
resource "azurerm_storage_data_lake_gen2_filesystem" "bikedatafs" {
  name               = "bikedatafs"
  storage_account_id = azurerm_storage_account.bikedatastc.id
}


# Create azure synapse workspace
resource "azurerm_synapse_workspace" "bikedataspace" {
  name                                 = "bikedataspace"
  resource_group_name                  = azurerm_resource_group.dataeng.name
  location                             = azurerm_resource_group.dataeng.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.bikedatafs.id
  sql_administrator_login              = "china"
  sql_administrator_login_password     = "bebe1234!"
}

# Create azure synapse firewall rule
resource "azurerm_synapse_firewall_rule" "allowAcc" {
  name                 = "allowAcc"
  synapse_workspace_id = azurerm_synapse_workspace.bikedataspace.id
  start_ip_address     = "0.0.0.0"
  end_ip_address       = "255.255.255.255"
}

# Create dedicated sql pool 
resource "azurerm_synapse_sql_pool" "bikedatapool" {
  name                 = "bikedatapool"
  synapse_workspace_id = azurerm_synapse_workspace.bikedataspace.id
  sku_name             = "DW100c"
  create_mode          = "Default"
}


resource "time_sleep" "wait_for_synapse" {
  create_duration = "60s"

  depends_on = [azurerm_synapse_firewall_rule.allowAcc]
}

#linked service for blob storage
resource "azurerm_synapse_linked_service" "bloblink" {
  name                 = "bloblink"
  synapse_workspace_id = azurerm_synapse_workspace.bikedataspace.id
  type                 = "AzureBlobStorage"
  type_properties_json = <<JSON
{
  "connectionString": "${azurerm_storage_account.bikedatastc.primary_connection_string}"
}
JSON
  
  depends_on = [time_sleep.wait_for_synapse]
}

#linked service for postgres
resource "azurerm_synapse_linked_service" "postgreslink" {
  name                 = "postgreslink"
  synapse_workspace_id = azurerm_synapse_workspace.bikedataspace.id
  type                 = "AzurePostgreSql"
  type_properties_json = <<JSON
{
  "connectionString": "host=bikedata.postgres.database.azure.com; port=5432; database=postgres; UID=china; password=bebe1234!; EncryptionMethod=1"
}
JSON

  depends_on = [
    azurerm_synapse_firewall_rule.allowAcc]
}
