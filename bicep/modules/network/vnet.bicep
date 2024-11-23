@description('Resource Name.')
param vnet_name string

@description('Resource Location.')
param vnet_location string = resourceGroup().location

@description('Address space for this virtual network.')
param vnet_address_prefixes array

@description('Array of subnets.')
param vnet_subnets subnet

// Custom data type for object of type subnet
type subnet = {
  name: string
  properties: {
    addressPrefix: string
    delegations: [
      {
        name: string
        properties: {
          serviceName: string
        }
      }
    ]?
  }
}[]

resource virtual_network 'Microsoft.Network/virtualNetworks@2024-03-01' = {
  name: vnet_name
  location: vnet_location
  properties: {
    addressSpace: {
      addressPrefixes: vnet_address_prefixes
    }
    subnets: vnet_subnets
  }
}

// Export array of subnets in main.bicep
output subnets array = virtual_network.properties.subnets
