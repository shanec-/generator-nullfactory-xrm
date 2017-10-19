
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
# Import common functions
. .\CrmInstance.Common.ps1

if (-Not (Get-Module -ListAvailable -Name Microsoft.Xrm.OnlineManagementAPI)) {
    Write-Verbose "Initializing Microsoft.Xrm.OnlineManagementAPI module ..."
    Install-Module -Name Microsoft.Xrm.OnlineManagementAPI -Scope CurrentUser -ErrorAction SilentlyContinue -Force
}

$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

# retrieve the service versionId here
if(-Not $serviceVersionId)
{
    $serviceVersionId = Get-CrmServiceVersionByName $apiUrl $creds $serviceVersionName
}

#$testTemplateList = @("D365_Sales", "D365_CustomerService", "D365_FieldService", "D365_ProjectServiceAutomation")

$newInstanceInfo = New-CrmInstanceInfo -BaseLanguage $baseLanguage -DomainName $domainName -InitialUserEmail $initialUserEmail -ServiceVersionId $serviceVersionId -InstanceType $instanceType -FriendlyName $friendlyName -TemplateList $templatesList
        #[-TemplateList
#<List[string]>] [-Purpose <string>] [-SecurityGroupId <guid>] [-CurrencyCode <string>] [-CurrencyName <string>]
#[-CurrencyPrecision <int>] [-CurrencySymbol <string>]  [<CommonParameters>]

$newInstanceJob = New-CrmInstance -ApiUr $apiUrl -Credential $creds -NewInstanceInfo $newInstanceInfo

$operationId = $newInstanceJob.OperationId 
$operationStatus = $newInstanceJob.Status

Write-Host "OperationId: $operationId Status: $operationStatus"

Wait-CrmOperation $apiUrl $creds $operationId
 
Write-Host "Creation of a new instance timed out."
exit 1