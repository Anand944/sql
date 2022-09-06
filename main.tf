resource "azurerm_resource_group" "rg" {
  name     = "rg01"
  location = "East Us"
}

resource "azurerm_sql_server" "sqlserver" {
  name                         = "myssqlserver01"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "adm-anand"
  administrator_login_password = "Siddu@20222022"

  tags = {
    environment = "production"
  }
}
resource "azurerm_sql_firewall_rule" "sqlfirewall" {
  name                = "FirewallRule07"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.sqlserver.name
  start_ip_address    = "10.0.17.62"
  end_ip_address      = "10.0.17.62"
}
resource "azurerm_storage_account" "storageaccount" {
  name                     = "storage08"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_database" "db" {
  name                = "db02"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  server_name         = azurerm_sql_server.sqlserver.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.storageaccount.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.storageaccount.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }



  tags = {
    environment = "production"
  }
}