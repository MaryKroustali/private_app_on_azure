//////// Application Resources ////////

targetScope = 'subscription'

param application string

var vnet_rg_name = 'rg-network-infra-${application}'
var snet_pep_name = 'snet-pep-vnet-${application}'
var snet_app_name = 'snet-app-vnet-${application}'
var vnet_name = 'vnet-${application}'
var common_rg_name = 'rg-common-infra-${application}'
var log_name = 'log-${application}'


// Existing resources from previous deployments
resource vnet 'Microsoft.Network/virtualNetworks@2024-03-01' existing = {
  scope: resourceGroup(vnet_rg_name)
  name: vnet_name
}

resource snet_pep 'Microsoft.Network/virtualNetworks/subnets@2024-03-01' existing = {
  parent: vnet
  name: snet_pep_name
}

resource snet_app 'Microsoft.Network/virtualNetworks/subnets@2024-03-01' existing = {
  parent: vnet
  name: snet_app_name
}

resource log 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  scope: resourceGroup(common_rg_name)
  name: log_name
}


resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'rg-application-infra-${application}'
  location: 'northeurope'
}

module asp '../modules/webapp/asp.bicep' = {
  scope: rg
  name: 'deploy-asp-${application}'
  params: {
    kind: 'app'  // Windows Webapp
    name: 'asp-${application}'
    sku: 'B1'
    reserved: false // Windows OS required for .NET apps
  }
}

module app '../modules/webapp/app.bicep' = {
  scope: rg
  name: 'deploy-app-${application}'
  params: {
    name: 'app-${application}'
    asp_id: asp.outputs.id
    app_snet_id: snet_app.id
    pep_snet_id: snet_pep.id
    vnet_rg_name: vnet_rg_name
    appi_instrumentation_key: appi.outputs.instrumentation_key
    appi_connection_string: appi.outputs.connection_string
  }
}

module appi '../modules/webapp/insights.bicep' = {
  scope: rg
  name: 'deploy-appi-${application}'
  params: {
    name: 'appi-${application}'
    log_id: log.id
  }
}
