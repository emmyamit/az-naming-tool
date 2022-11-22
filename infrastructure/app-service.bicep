@description('Region for all resources in this module')
param location string

@description('Environment specific configuration settings')
param configuration object = {}

@description('Resource Tags')
param tags object = {}

@description('Runtime stack')
param linuxFxVersion string = 'DOTNETCORE|6.0'

@description('An App service plan to host the app')
resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: 'plan-${tags.Workload}-${tags.Artifact}-${tags.Environment}-${location}'
  location: location
  tags: tags
  sku: {
    name: configuration.sku
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

@description('An App service to host the app')
resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'app-${tags.Workload}-${tags.Artifact}-${tags.Environment}-${location}'
  location: location
  tags: tags
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      appSettings:[
        {
          name: 'SCM_MAX_ZIP_PACKAGE_COUNT'
          value: '1' // keeping only the recent zip uploaded to the app
        }
      ]
    }
  }
}

output appService object = webApp
