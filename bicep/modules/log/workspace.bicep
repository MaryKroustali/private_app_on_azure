@description('Resource Name.')
@minLength(4)
@maxLength(63)
param name string

@description('Name of the SKU for the Log Analytics Workspace.')
@allowed([
  'CapacityReservation'
  'Free'
  'LACluster'
  'PerGB2018'
  'PerNode'
  'Premium'
  'Standalone'
  'Standard' 
])
param skuName string

@description('Resource Location.')
param location string = resourceGroup().location

@description('The workspace data retention in days.')
param retentionInDays int?

resource log 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: name
  location: location
  properties:{
    sku: {
      name: skuName
    }
    retentionInDays: retentionInDays
  }
}
