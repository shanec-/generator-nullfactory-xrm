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

# Importing common functions
. .\CrmInstance.Common.ps1
Init-OmapiModule $username $password

# if an instance id is not provided then attempt to use the aliases
if(-Not $instanceId)
{
    $instanceId = Get-CrmInstanceByName $apiUrl $creds $friendlyName $uniqueName
}

Write-Verbose "InstanceId $instanceId"

$deleteJob = Remove-CrmInstance -ApiUrl $apiUrl -Credential $creds -Id $instanceId

$deleteOperationId = $deleteJob.OperationId 
$deleteOperationStatus = $deleteJob.Status

Write-Host "OperationId: $deleteOperationId Status: $deleteOperationStatus"

Wait-CrmOperation $apiUrl $creds $deleteOperationId
 
Write-Host "Delete instance operation timed out."
exit 1


