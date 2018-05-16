<#
  .SYNOPSIS
	  Provision a Dynamics 365 Customer Engagement Instance.
  .DESCRIPTION
    Provision a new Dynamics 365 Customer Engagement instance in the Office 365 tenant.
  .NOTES
    Author: Shane Carvalho
    Version: generator-nullfactory-xrm@1.6.0
  .LINK
    https://nullfactory.net
  .PARAMETER apiUrl
    Mandatory parameter, the service api url.
  .PARAMETER username
    The username used to connect to the service API.
  .PARAMETER password
    The password used to connect.
  .PARAMETER friendlyName
    The unique friendly name for the instance.
  .PARAMETER domainName
    The doman name for the instance.
	.PARAMETER initialUserEmail
		The initial user email address.
	.PARAMETER serviceVersionId
		The Version Id of the CRM Service. If one is not provided, the first available version will be used.
	.PARAMETER serviceVersionName
		The Service Version Name.
	.PARAMETER instanceType
		The type of the instance.
	.PARAMETER baseLanguage
		The base language code for the instance.
	.PARAMETER templatesList
		The templates to be used with this instance.
  .EXAMPLE
    .\Create-CrmInstance.ps1 -apiUrl "https://admin.services.crm6.dynamics.com" -username "admin@superinstance.onmicrosoft.com" -password "P@ssw0rd!" -friendlyname "SuperInstance" -domain "superinstance" -initialUserEmail "admin@superinstance.onmicrosoft.com" -templatesList "D365_Sales"
    Provisions a new instance with friendly name "SuperInstance" with the "Dynamics 365 Sales Application" pre-populated.
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
    [string]$friendlyName,
    [string]$domainName,
    [string]$initialUserEmail,
    [guid]$serviceVersionId,
    [string]$serviceVersionName,
    [ValidateSet('None', 'Production', 'Sandbox', 'Support', 'Preview', 'Trial')]
    [string]$instanceType = 'Sandbox',
    [int]$baseLanguage = 1033,
    [System.Array]$templatesList
)
$ErrorActionPreference = "Stop"

# Import common functions
. .\CrmInstance.Common.ps1
$creds = Init-OmapiModule $username $password

# retrieve the service versionId here
if(-Not $serviceVersionId)
{
    $serviceVersionId = Get-CrmServiceVersionByName $apiUrl $creds $serviceVersionName
}

$newInstanceInfo = New-CrmInstanceInfo -BaseLanguage $baseLanguage -DomainName $domainName -InitialUserEmail $initialUserEmail -ServiceVersionId $serviceVersionId -InstanceType $instanceType -FriendlyName $friendlyName -TemplateList $templatesList
$newInstanceJob = New-CrmInstance -ApiUr $apiUrl -Credential $creds -NewInstanceInfo $newInstanceInfo

Wait-CrmOperation -apiUrl $apiUrl -credentials $creds -sourceOperation $newInstanceJob

Write-Host "Creation of a new instance timed out."
exit 1
