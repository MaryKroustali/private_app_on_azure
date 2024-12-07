@description('Resource Name.')
param name string

@description('Resource Location.')
param location string = resourceGroup().location

@description('Resource ID of the associated App Service plan.')
param asp_id string

@description('Id of the delegated subnet of type \'Microsoft.Web/serverFarms\'')
param app_snet_id string

@description('Id of the private endpoints\' subnet.')
param pep_snet_id string

@description('Name of the Network Resources\' Resource Group.')
param vnet_rg_name string

@description('Instrumentation Key of the Application Insights resource.')
param appi_instrumentation_key string

@description('Connection string of the Application Insights resource.')
param appi_connection_string string


var dns_zone = 'privatelink.azurewebsites.net'  // Private DNS zone for web apps

resource app_service 'Microsoft.Web/sites@2023-12-01' = {
  name: name
  location: location
  properties: {
    serverFarmId: asp_id
    publicNetworkAccess: 'Disabled' // Disable public access to the application
    virtualNetworkSubnetId: app_snet_id  // Integrate with private network
    siteConfig: {
      appSettings: [  // Monitor the application using Application Insights
        { 
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appi_instrumentation_key
        }
        { 
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: appi_connection_string
        }
      ]
    }
  }
}

// A private endpoint is used to enable private access to the webapp
module pep '../network/pep.bicep' = {
  scope: resourceGroup(vnet_rg_name)
  name: 'deploy-pep-${name}'
  params: {
    name: 'pep-${name}'
    group_ids: [ 'sites' ]
    resource_id: app_service.id  // Connect this private endpoint to the app service
    snet_id: pep_snet_id
    dns_zone: dns_zone
  }
}

output domain string = app_service.properties.defaultHostName
