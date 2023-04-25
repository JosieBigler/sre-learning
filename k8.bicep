@description('Specifies the location for resources.')
param location string = resourceGroup().location



// Create a Virtual Network 
module virtualNetwork 'network.bicep' = {
  name: 'virtualNetwork'
  params: {
    location: location
  }
}

//Create a firewall for my virtual network 
// .. .. We'll do this later? 
// @description('Azure Firewall name')
// param firewallName string = 'fw${uniqueString(resourceGroup().id)}'
// param firewallPolicyName string = '${firewallName}-firewallPolicy'


//Create public IP Address for load balancer
var publicIP = 'loadBalancerIP'

resource loadBalancerIP 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: publicIP
}

//Kubernetes Controllers 
// resource vmController 'Microsoft.Compute/virtualMachines@2022-03-01' = [for i in range(0, 3): {
//   location: location
//   name: 'controller-${i}'
// }]

var adminUserName = 'jnsgaming'
var adminPassword = 'Fs4t754dw2sdc5'

module vmControllers './vm.bicep' = [for i in range(0, 3): {
  name: 'controller-${i}'
  params: {
    vmName: 'controllervm${i}'
    adminPasswordOrKey: adminPassword
    adminUsername: adminUserName
    subnetId: virtualNetwork.outputs.subnetid
    location: location
  }
}]

//Kibernetes Workers
module vmWorkers './vm.bicep' = [for i in range(0, 3): {
  name: 'worker-${i}'
  params: {
    vmName: 'workervm${i}'
    adminPasswordOrKey: adminPassword
    adminUsername: adminUserName
    subnetId: virtualNetwork.outputs.subnetid
    location: location
  }
}]
