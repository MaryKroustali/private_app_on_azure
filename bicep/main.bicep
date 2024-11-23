param application string
param sql_server_admin_username string
@secure()
param sql_server_admin_password string
param sql_db_name string

// Private Virtual Network
module vnet 'modules/network/vnet.bicep' = {
  name: 'deploy-vnet-${application}'
  params: {
    vnet_address_prefixes: ['10.1.0.0/28']
    vnet_name: 'vnet-${application}'
    vnet_subnets: [
      { // Subnet for webapps, must be delegated for 'Microsoft.Web/serverFarms'
        // https://learn.microsoft.com/en-us/azure/virtual-network/subnet-delegation-overview
        name: 'snet-app-vnet-${application}'
        properties: {
          addressPrefix: '10.1.0.0/28'
          delegations: [
            {
              name: 'Microsoft.Web.serverFarms'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
      { // Subnet for private endpoints of the resources
        name: 'snet-pep-vnet-${application}'
        properties: {
          addressPrefix: '10.1.0.16/28'
        }
      }
    ]
  }
}

module asp 'modules/webapp/asp.bicep' = {
  name: 'deploy-asp-${application}'
  params: {
    asp_kind: 'app'  // Windows Webapp
    asp_name: 'asp-${application}'
    asp_sku: 'F1'
  }
}

module app 'modules/webapp/app.bicep' = {
  name: 'deploy-app-${application}'
  params: {
    app_name: 'app-${application}'
    app_service_plan_id: asp.outputs.id
    app_snet_id: vnet.outputs.subnets[0].id
  }
}

module sql_server 'modules/sql/server.bicep' = {
  name: 'deploy-sql-${application}'
  params: {
    sql_server_admin_password: sql_server_admin_password
    sql_server_admin_username: sql_server_admin_username
    sql_server_name: 'sql-${application}'
  }
}

module sql_db 'modules/sql/database.bicep' = {
  name: 'deploy-sql-db-${application}'
  params: {
    sql_db_name: sql_db_name
    sql_server_name: sql_server.outputs.name
  }
}
