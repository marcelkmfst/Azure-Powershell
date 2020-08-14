### Note, this create-azdiagpolicy.ps1 is from the 12th August 2020, check frequently for updates in the official 
### Github repo https://github.com/JimGBritt/AzurePolicy/tree/master/AzureMonitor/Scripts

# There are multiple options to import the Policies, below example is for a single one

Select-AzSubscription -SubscriptionName "MK101-Hub-Subscription"

$definition = New-AzPolicyDefinition -Name "apply-diagnostic-setting-azsql-loganalytics" `
 -Metadata '{ "category":"Monitoring" }' `
 -DisplayName "[Demo]Apply Diagnostic Settings for Azure SQL to a Log Analytics Workspace" `
 -description "This policy automatically deploys diagnostic settings for Azure SQL to point to a Log Analytics Workspace." `
 -Policy azurepolicy.rules.json
 -Parameter azurepolicy.parameters.json

$definition


# more useful is to let the script generate an ARM template which deploys an initiative including policies
# for all services found. The can works also at a management group level

.\Create-AzDiagPolicy.ps1 -ExportAll -ExportLA -ValidateJSON -ExportDir ".\DiagPolicies" -ManagementGroup -AllRegions -ExportInitiative -InitiativeDisplayName "Azure Diagnostics Policy Initiative for a Log Analytics Workspace" -TemplateFileName 'ARMTemplateExport'

# In order to deploy the initative to a management group instead of a subscription, new-azmanagementgroupdeployment
# must be used 

New-AzManagementGroupDeployment -Name "diagpolicymgmtgroup" -TemplateFile ARMTemplateExport.json -Location 'West Europe' -ManagementGroupId "110c879b-9489-4244-9d7e-113d8dcf5875" -verbose


# new-azdeployment provisions the policy initative at the Subscription level (the current selected one)
New-AzDeployment -Name "diagpolicy" -TemplateFile ARMTemplateExport.json -Location 'West Europe' -Verbose


