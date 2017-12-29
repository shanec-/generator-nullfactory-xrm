<#
  .SYNOPSIS
		Deletes a Dynamics 365 Customer Engagement Instance.
  .DESCRIPTION
    Delete a Customer Engagement instance using one of the unique identifiers or friendly names.
  .NOTES
    Author: Shane Carvalho
    Version: generator-nullfactory-xrm@1.6.0
  .LINK
    https://nullfactory.net
  .PARAMETER apiUrl
    The service api url.
  .PARAMETER username
    The username used to connect to the service API.
  .PARAMETER password
    The password used to connect.
  .PARAMETER instanceId
    The unique identifier for the instance.
  .PARAMETER friendlyName
    The unique friendly name for the instance.
  .PARAMETER uniqueName
    The unique name for the instance.
  .EXAMPLE
		.\Delete-CrmInstance.ps1 -apiUrl "https://admin.services.crm6.dynamics.com" -username "admin@myinstance.onmicrosoft.com" -password "P@ssw0rd!" -friendlyname "SuperInstance"
		.\Delete-CrmInstance.ps1 -apiUrl "https://admin.services.crm6.dynamics.com" -username "admin@myinstance.onmicrosoft.com" -password "P@ssw0rd!" -uniqueName "org009383"
		.\Delete-CrmInstance.ps1 -apiUrl "https://admin.services.crm6.dynamics.com" -username "admin@myinstance.onmicrosoft.com" -password "P@ssw0rd!" -instanceId "e300d144-3fc6-4d4c-8f34-c10e3ad00572"
#>
[CmdletBinding(DefaultParameterSetName = "Internal")]
param(
    [Parameter(Mandatory = $true, Position = 1)]
    [ValidateSet('https://admin.services.crm.dynamics.com',
        'https://admin.services.crm9.dynamics.com',
        'https://admin.services.crm4.dynamics.com',
        'https://admin.services.crm5.dynamics.com',
        'https://admin.services.crm6.dynamics.com',
        'https://admin.services.crm7.dynamics.com',
        'https://admin.services.crm2.dynamics.com',
        'https://admin.services.crm8.dynamics.com',
        'https://admin.services.crm3.dynamics.com',
        'https://admin.services.crm11.dynamics.com')]
    [string]$apiUrl,
    [Parameter(Mandatory = $true, Position = 2)]
    [string]$username,
    [Parameter(Mandatory = $true, Position = 3)]
    [string]$password,
    [guid]$instanceId,
    [string]$friendlyName,
    [string]$uniqueName
)
$ErrorActionPreference = "Stop"

# Importing common functions
. .\CrmInstance.Common.ps1
$creds = Init-OmapiModule $username $password

# if an instance id is not provided then attempt to use the aliases
if(-Not $instanceId)
{
    $instanceId = Get-CrmInstanceByName $apiUrl $creds $friendlyName $uniqueName -ErrorAction Stop
}

Write-Verbose "Resolved InstanceId: $instanceId"

$deleteJob = Remove-CrmInstance -ApiUrl $apiUrl -Credential $creds -Id $instanceId

Wait-CrmOperation -apiUrl $apiUrl -Credentials $creds -sourceOperation $deleteJob

Write-Host "Delete instance operation timed out."
exit 1
