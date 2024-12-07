@description('Resource Name.')
param name string

@description('Resource Location.')
param location string = resourceGroup().location

@description('The administrator login username for the server.')
@secure()
param admin_username string

@description('The administrator login password for the server.')
@secure()
param admin_password string

@description('Id of the private endpoints\' subnet.')
param pep_snet_id string

@description('Name of the Network Resources\' Resource Group.')
param vnet_rg_name string

var dns_zone = 'privatelink.azurewebsites.net'  // Private DNS zone for web apps

resource sql_server 'Microsoft.Sql/servers@2023-08-01-preview' = {
  name: name
  location: location
  properties: {
    administratorLogin: admin_username
    administratorLoginPassword: admin_password
    publicNetworkAccess: 'Disabled' // Disable public access to the sql server
  }
}

// Existing resource group with network resources
resource vnet_rg 'Microsoft.Resources/resourceGroups@2024-07-01' existing = { 
  scope: subscription()
  name: vnet_rg_name
} 

// A private endpoint is used to enable private access to the server
module pep '../network/pep.bicep' = {
  scope: vnet_rg
  name: 'deploy-pep-${name}'
  params: {
    name: 'pep-${name}'
    group_ids: [ 'sqlServer' ]
    resource_id: sql_server.id  // Connect this private endpoint to the sql server
    snet_id: pep_snet_id
    dns_zone: dns_zone
  }
}

output name string = sql_server.name
