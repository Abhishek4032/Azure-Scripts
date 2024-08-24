Get-AzureRmWebsite | Where {$_.Name -notin $websitesToSave} | Remove-AzureWebsite -Force
Get-AzureRmService | Where {$_.Label -notin $VMsToSave} | Remove-AzureService -Force
Get-AzureRmDisk | Where {$_.AttachedTo -eq $null} | Remove-AzureDisk -DeleteVHD
Get-AzureRmStorageAccount | Where {$_.Label -notin $storageAccountsToSave} | Remove-AzureStorageAccount
Get-AzureAffinityGroup | Remove-AzureAffinityGroup
Remove-AzureVNetConfig

Get-AzureRmDisk | Where {$_.AttachedTo -eq $null}
Get-AzureRmDisk | Where {$_.AttachedTo -eq $null} | Format-List or Format-Table -Property DiskState, Name
Get-AzureRmDisk | Where {$_.AttachedTo -eq $null} | Export-Csv -Path ./<Give Any Name>
Or
Get-AzureRmDisk | Where {$_.AttachedTo -eq $null} | Select-Object -Property DiskState, Name
Get-AzureRmDisk | Where {$_.AttachedTo -eq $null} | Export-Csv -Path ./<Give Any Name>


1- Current two environments. Development and Production subscription. Is this the best practice ?
   I think we can use one subcription for both of the Env. There are many options like staging slots we can use
   or also Azure Emulator for the cost cutting.

2- Create new QA subscription or limit developer access to one resource groups but give them full rights to this ?
   This should be depend on scenario

3- How can we garbage collect old resources?
   There are many things we can do for it:-
   We can do this manual.
   We can use the PowerShell Script to find out UnAttached resources.
   But for few of them we should use manual like for Storage Accounts,
   Sql,etc. In this scenario we can go for activity logs to find out the last usage date.

4- Event manager to find out who created a resource in Azure?
   We can use Activity Logs to find out who has created the resources,
   but that is limited for 90 days.
   We Can use Log Analytics account to get the 1st process details or more than 90 days,
   Query Is:-
   AzureActivity
 | where ResourceGroup == "ResourceGroupName"and Resource == "ResourceName"
 | where ActivityStatus == "Succeeded" 
 | top 1 by EventSubmissionTimestamp asc 
 | project Caller

5- This is not available OOTB. We have to build something custom solution or build custom logging queries?

6- Can we trigger logs in Azure?
   We can use the alerts for the trigger the logs to owner,
   Just go to monitoring and select the alerts ans create rule.
   Or We can go for automation account there we can create Runbooks to run your task automatically.

7- Using ARM Templates-
   {
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "",



  "parameters": {  },
  "variables": {  },
  "functions": [  ],
  "resources": [  ],
  "outputs": {  }
}

$schema		Location of the JSON schema file that describes the version of the template language.
		For resource group deployments, use: https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#
		For subscription deployments, use: https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#

contentVersion	Version of the template (such as 1.0.0.0). You can provide any value for this element. Use this value to document significant changes
		in your template. When deploying resources using the template, this value can be used to make sure that the right template is being used.

apiProfile	An API version that serves as a collection of API versions for resource types. Use this value to avoid having to specify API versions for 
		each resource in the template. When you specify an API profile version and don't specify an API version for the resource type, Resource 
		Manager uses the API version for that resource type that is defined in the profile.

parameters	Values that are provided when deployment is executed to customize resource deployment.

variables	Values that are used as JSON fragments in the template to simplify template language expressions.

functions	User-defined functions that are available within the template.

resources	Resource types that are deployed or updated in a resource group or subscription.

outputs		Values that are returned after deployment.

Syntax:-
parameters

"parameters": {
  "storageSKU": {
    "type": "string",
    "allowedValues": [
      "Standard_LRS",
      "Standard_ZRS",
      "Standard_GRS",
      "Standard_RAGRS",
      "Premium_LRS"
    ],
    "defaultValue": "Standard_LRS",
    "metadata": {
      "description": "The type of replication to use for the storage account."
    }
  }   
}

============================================================================================================================
variables

"variables": {
  "<variable-name>": "<variable-value>",
  "<variable-name>": { 
    <variable-complex-type-value> 
  },
  "<variable-object-name>": {
    "copy": [
      {
        "name": "<name-of-array-property>",
        "count": <number-of-iterations>,
        "input": <object-or-value-to-repeat>
      }
    ]
  },
  "copy": [
    {
      "name": "<variable-array-name>",
      "count": <number-of-iterations>,
      "input": <object-or-value-to-repeat>
    }
  ]
}

"variables": {
  "storageName": "[concat(toLower(parameters('storageNamePrefix')), uniqueString(resourceGroup().id))]"
},

============================================================================================================================
resources

"resources": [
  {
    "name": "[variables('storageName')]",
    "type": "Microsoft.Storage/storageAccounts",

============================================================================================================================
functions

"functions": [
  {
    "namespace": "contoso",
    "members": {
      "uniqueName": {
        "parameters": [
          {
            "name": "namePrefix",
            "type": "string"
          }
        ],
        "output": {
          "type": "string",
          "value": "[concat(toLower(parameters('namePrefix')), uniqueString(resourceGroup().id))]"
        }
      }
    }
  }
],
