@description('Resource Name.')
param sql_server_name string

@description('Resource Location.')
param sql_server_location string = resourceGroup().location

@description('The administrator login username for the server.')
param sql_server_admin_username string

@description('The administrator login password for the server.')
@secure()
param sql_server_admin_password string

resource sql_server 'Microsoft.Sql/servers@2023-08-01-preview' = {
  name: sql_server_name
  location: sql_server_location
  properties: {
    administratorLogin: sql_server_admin_username
    administratorLoginPassword: sql_server_admin_password
  }
}

output name string = sql_server.name
