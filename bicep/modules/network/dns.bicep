@description('Resource Name.')
param name string

@description('Resource Id of the Virtual Network to link DNS zones to.')
param vnet_id string

@description('Whether auto-registration of virtual machine records in the virtual network in the Private DNS zone is enabled.')
param registrationEnabled bool = false

resource dns 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  location: 'global'
  name: name
}

// Link Private DNS zone with Virtual Network
resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: dns
  name: 'vnet-link'
  location: 'global'
  properties: {
    registrationEnabled: registrationEnabled
    virtualNetwork: {
      id: vnet_id
    }
  }
}
