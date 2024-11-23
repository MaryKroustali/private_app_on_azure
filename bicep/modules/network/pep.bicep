@description('Resource Name.')
param name string

@description('Name of the subnet from where private endpoints get their private addresses.')
param snet_name string

@description('')
param resource string

// Reference to existing subnet for private endpoints
resource pep_subnet 'Microsoft.Network/virtualNetworks/subnets@2024-03-01' existing = {
  name: snet_name
}

resource pep 'Microsoft.Network/privateEndpoints@2024-03-01' = {
  name: name
  properties: {
    subnet: pep_subnet
    privateLinkServiceConnections: [
      {
        name: 'privatelink'
        properties: {
          privateLinkServiceId:
          groupIds: [

          ]
        }
      }
    ]
  }
}
