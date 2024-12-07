@description('Resource Name.')
param name string

@description('Resource Location.')
param location string = resourceGroup().location

@description('The kind of application that this component refers to. Typically should be one of the following: web, ios, other, store, java, phone.')
param kind string = 'web'

resource insights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  kind: kind
}
