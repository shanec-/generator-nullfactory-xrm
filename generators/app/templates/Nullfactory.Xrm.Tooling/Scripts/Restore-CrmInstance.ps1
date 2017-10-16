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
    [guid]$sourceInstanceId,
    [string]$sourceInstanceFriendlyName,
    [string]$sourceInstanceUniqueName,
    [guid]$targetInstanceId,
    [string]$targetInstanceFriendlyName,
    [string]$targetInstanceUniqueName,
    [guid]$backupId,
    [string]$backupLabel,
)

# Importing common functions
. .\CrmInstance.Common.ps1

if (-Not (Get-Module -ListAvailable -Name Microsoft.Xrm.OnlineManagementAPI)) {
    Write-Verbose "Initializing Microsoft.Xrm.OnlineManagementAPI module ..."
    Install-Module -Name Microsoft.Xrm.OnlineManagementAPI -Scope CurrentUser -ErrorAction SilentlyContinue -Force
}

# if an instance id is not provided then attempt to use the aliases provided
if(-Not $sourceInstanceId)
{
    $sourceInstanceId = Get-CrmInstanceByName $apiUrl $creds $sourceInstanceFriendlyName $sourceInstanceUniqueName
}

if (-Not $targetInstanceId)
{
    $targetInstanceId = Get-CrmInstanceByName $apiUrl $creds $targetInstanceFriendlyName $targetInstanceUniqueName
}

if (-Not $backupId)
{
    $backupId = Get-CrmInstanceBackupByLabel $apiUrl $creds $backupLabel
}

$restoreJob = Restore-CrmInstance -ApiUrl $apiUrl `
    -Credential $creds `
    -BackupId $backupId `
    -SourceInstanceId $sourceInstanceId `
    -TargetInstanceId $targetInstanceId

$restoreOperationId = $restoreJob.OperationId 
$restoreOperationStatus = $restoreJob.Status
    
Write-Host "OperationId: $restoreOperationId Status: $restoreOperationStatus"
    
Wait-CrmOperation $apiUrl $creds $restoreOperationId