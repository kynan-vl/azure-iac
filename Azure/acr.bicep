// Set the name of the ACR
param acrName string = 'kvlAcr'

// Get the location of the resource group
param location string = resourceGroup().location

// Create the ACR resource
resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  // Set the properties such as name, location and stock keeping unit
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
}

