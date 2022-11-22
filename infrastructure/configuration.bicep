@description('Environment name')
@allowed([
  'dev'
  'qa'
  'uat'
  'bfx'
  'prd'
])
param environment string

var environmentConfigurationMap = {
  dev: {
    sku: 'F1'
    monitorable: 'N' // Flag to indicate if the app needs to be monitored on dynatrace. Y for Yes, N for No
    allowedIpAddressCIDRs: ['47.14.119.47/32'] // List of the IP's allowed to view the App in non-production environments
  }
}

output settings object = environmentConfigurationMap[environment]
