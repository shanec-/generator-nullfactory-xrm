<#
	.SYNOPSIS
		Restore a backup from a source instance to a destination instance.
	.DESCRIPTION
		Restore a backup from a source instance to a destination instance using one of the unique identifiers or friendly names.
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
	.PARAMETER sourceInstanceId
		The unique identifier for the source instance.
	.PARAMETER sourceFriendlyName
		The unique friendly name for the source instance.
	.PARAMETER sourceUniqueName
		The unique name for the source instance.
	.PARAMETER targetInstanceId
		The unique identifier for the target instance.
	.PARAMETER targetFriendlyName
		The unique friendly name for the target instance.
	.PARAMETER targetUniqueName
		The unique name for the target instance.
	.PARAMETER backupId
		The unique identifier for the backup.
	.PARAMETER backupLabel
		The label of the backup being restored.
	.EXAMPLE
		.\Restore-CrmInstance.ps1 -apiUrl "https://admin.services.crm6.dynamics.com" -username "admin@superinstance.onmicrosoft.com" -password "Pass@word1" -sourceFriendlyName "indie" -targetFriendlyName "indie" -backupLabel "prod-backup1"
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
    [guid]$sourceInstanceId,
    [string]$sourceFriendlyName,
    [string]$sourceUniqueName,
    [guid]$targetInstanceId,
    [string]$targetFriendlyName,
    [string]$targetUniqueName,
    [guid]$backupId,
    [string]$backupLabel
)

$ErrorActionPreference = "Stop"

# Importing common functions
. .\CrmInstance.Common.ps1
$creds = Init-OmapiModule $username $password

# if an instance id is not provided then attempt to use the aliases provided
if(-Not $sourceInstanceId)
{
    $sourceInstanceId = Get-CrmInstanceByName $apiUrl $creds $sourceFriendlyName $sourceUniqueName
}

Write-Verbose "Resolved SourceInstanceId: $sourceInstanceId"

if (-Not $targetInstanceId)
{
    $targetInstanceId = Get-CrmInstanceByName $apiUrl $creds $targetFriendlyName $targetUniqueName
}

Write-Verbose "Resolved TargetInstanceId: $targetInstanceId"

if (-Not $backupId)
{
    $backupId = Get-CrmInstanceBackupByLabel $apiUrl $creds $sourceInstanceId $backupLabel
}

Write-Verbose "BackupId resolved: $backupId"

$restoreJob = Restore-CrmInstance -ApiUrl $apiUrl `
    -Credential $creds `
    -BackupId $backupId `
    -SourceInstanceId $sourceInstanceId `
    -TargetInstanceId $targetInstanceId

Wait-CrmOperation -apiUrl $apiUrl -credentials $creds -sourceOperation $restoreJob

Write-Host "Restore operation timed out."
exit 1
