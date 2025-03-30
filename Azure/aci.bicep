// Set the name of the login server
param acrLoginServer string = 'kvlacr.azurecr.io'

// Set the name of the ACR Token
param acrUsername string = 'kvlAcrToken'

// Set the name of ACR
param acrName string = 'kvlAcr'

// Set the name of container
param containerName string = 'kvl-flask-crud-app'

// Get the location of the resource group
param location string = resourceGroup().location

// Set the password of the Token, handled in a secure way (via cli)
@secure()
param acrPassword string

// Check if the ACR resource exists
resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: acrName
}

// Create the ACI resource
resource aci 'Microsoft.ContainerInstance/containerGroups@2022-09-01' = {
  // Set the name and location of the ACI
  name: containerName
  location: location
  properties: {
    containers: [
      {
        // Specify which image to use from the registry
        name: containerName
        properties: {
          image: '${acr.properties.loginServer}/kvl-flask-crud-app:v1'
          // Set the ports which will be opened and the protocol to use
          ports: [
            {
              protocol: 'TCP'
              port: 80
            }
          ]
          // Set the resources of the container
          resources: {
            requests: {
              cpu: 1
              memoryInGB: 2
            }
          }
        }
      }
    ]
    // Set the credentials to use to authenticate with the ACR
    imageRegistryCredentials: [
      {
        server: acrLoginServer
        username: acrUsername
        password: acrPassword
      }
    ]
    // Specify which operating system will be used
    osType: 'Linux'
    // Create a public ip adress on port 80
    ipAddress: {
      type: 'Public'
      dnsNameLabel: '${containerName}-dns'
      ports: [
        {
          protocol: 'TCP'
          port: 80
        }
      ]
    }
  }
}


