@description('Resource Name.')
param sql_db_name string

@description('Resource Location.')
param sql_db_location string = resourceGroup().location

@description('Name of the associated SQL Server.')
param sql_server_name string

resource sql_server 'Microsoft.Sql/servers@2023-08-01-preview' existing = {
  name: sql_server_name
}

resource sqql_database 'Microsoft.Sql/servers/databases@2023-08-01-preview' = {
  parent: sql_server
  name: sql_db_name
  location: sql_db_location
}
