
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
    [string]$uniqueName,
    [string]$backupLabel,
    [string]$backupNotes
)

# Importing common functions
. .\CrmInstance.Common.ps1

if (-Not (Get-Module -ListAvailable -Name Microsoft.Xrm.OnlineManagementAPI)) {
    Write-Verbose "Initializing Microsoft.Xrm.OnlineManagementAPI module ..."
    Install-Module -Name Microsoft.Xrm.OnlineManagementAPI -Scope CurrentUser -ErrorAction SilentlyContinue -Force
}

# if a backup label is not provided, generate one
if (-Not $backupLabel) {
    $backupLabel = Get-Date -Format "G"
    Write-Verbose -Message "Backup label not provided, defaulting it to $backupLabel"
}

$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

# if an instance id is not provided then attempt to use the aliases
if(-Not $instanceId)
{
    $instanceId = Get-CrmInstanceByName $apiUrl $creds $friendlyName $uniqueName
}

Write-Verbose "InstanceId $instanceId"

$backupInfoRequest = New-CrmBackupInfo -InstanceId $instanceId -Label $backupLabel -Notes $backupNotes
$backupJob = Backup-CrmInstance -ApiUrl $apiUrl -Credential $creds -BackupInfo $backupInfoRequest

$backupOperationId = $backupJob.OperationId 
$backupOperationStatus = $backupJob.Status

Write-Host "OperationId: $backupOperationId Status: $backupOperationStatus"

$timeout = new-timespan -Minutes 5
$sw = [diagnostics.stopwatch]::StartNew()
while ($sw.elapsed -lt $timeout)
{
    Write-Host $apiUrl
    Write-Host $creds
    Write-Host $backupOperationId

    $opStatus = Get-CrmOperationStatus -apiUrl $apiUrl -Credential $creds -Id $backupOperationId
    
    Write-Host $opStatus.Status

    # determinate statuses
    if($opStatus.Status -eq "Succeeded")
    {
        Write-Host "Backup operation completed successfully!" -ForegroundColor Green
        exit 0
    }
    elseif(@("FailedToCreate", "Failed", "Cancelling", "Cancelled", "Aborting", "Aborted", "Tombstone", "Deleting", "Deleted") -contains $opStatus)
    {
        throw "Failed to create backup";
    }
    # indeterminate statuses
    elseif(@("None", "NotStarted", "Ready", "Pending", "Running") -contains $opStatus)
    {
        Write-Verbose "Indeterminate status."
    }

    start-sleep -Seconds 60
}
 
write-host "Create backup operation timeout."
exit 1