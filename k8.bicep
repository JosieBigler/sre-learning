@description('Specifies the location for resources.')
param location string = resourceGroup().location



// Create a Virtual Network 
var subnetName = 'test'
var myVirtualNetwork = 'myVirtualNetwork'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-09-01' = {
  name: myVirtualNetwork
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}

//Create a firewall for my virtual network 
// .. .. We'll do this later? 
@description('Azure Firewall name')
param firewallName string = 'fw${uniqueString(resourceGroup().id)}'
param firewallPolicyName string = '${firewallName}-firewallPolicy'


//Create public IP Address for load balancer
var publicIP = 'loadBalancerIP'

resource loadBalancerIP 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: publicIP
}


//Kubernetes Controllers 
resource vmController 'Microsoft.Compute/virtualMachines@2022-03-01' = [for i in range(0, 3): {
  location: location
  name: 'controller-${i}'
}]




//Kibernetes Workers
