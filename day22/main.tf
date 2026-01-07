resource "azurerm_resource_group" "rg" {
  name = "my-sql-server-rg"
  location = "canada central"
}

resource "azurerm_mssql_server" "sqlserver" {
  name = "my-sql-server"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  version = "12.0"
  administrator_login = "sqladmin"
  administrator_login_password = "StrongPass@1234"

}


resource "azurerm_mssql_database" "sampledb" {
  name = "sample-db"
  server_id = azurerm_mssql_server.sqlserver.id
}


resource "azurerm_mssql_firewall_rule" "firewall_rule" {
  name = "mysql-server-firewall"
  server_id = azurerm_mssql_server.sqlserver.id
  start_ip_address = "123.108.228.2"
  end_ip_address = "123.108.228.2"

}


