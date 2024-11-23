@description('Resource Name.')
param asp_name string

@description('Resource Location.')
param asp_location string = resourceGroup().location

@description('''Kind of resource. If the resource is an app, you can refer to 
https://github.com/Azure/app-service-linux-docs/blob/master/Things_You_Should_Know/kind_property.md#app-service-resource-kind-reference 
for details supported values for kind.''')
param asp_kind string

@description('Name of the SKU capability.')
param asp_sku string

resource app_service_plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: asp_name
  location: asp_location
  properties: {
    reserved: true
  }
  sku: {
    name: asp_sku
  }
  kind: asp_kind
}

output id string = app_service_plan.id
