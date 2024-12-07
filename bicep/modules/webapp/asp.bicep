@description('Resource Name.')
param name string

@description('Resource Location.')
param location string = resourceGroup().location

@description('''Kind of resource. If the resource is an app, you can refer to 
https://github.com/Azure/app-service-linux-docs/blob/master/Things_You_Should_Know/kind_property.md#app-service-resource-kind-reference 
for details supported values for kind.''')
param kind string

@description('For Windows app service plan `false`, `true` for Linux.')
param reserved bool

@description('Name of the SKU capability.')
param sku string

resource app_service_plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: name
  location: location
  properties: {
    reserved: reserved
  }
  sku: {
    name: sku
  }
  kind: kind
}

output id string = app_service_plan.id
