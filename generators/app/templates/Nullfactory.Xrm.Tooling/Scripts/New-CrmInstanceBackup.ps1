
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
    [string]$uniqueName,
    [string]$backupLabel,
    [string]$backupNotes
)


if (-Not (Get-Module -ListAvailable -Name Microsoft.Xrm.OnlineManagementAPI)) {
    Write-Verbose "Initializing Microsoft.Xrm.OnlineManagementAPI module ..."
    Install-Module -Name Microsoft.Xrm.OnlineManagementAPI -Scope CurrentUser -ErrorAction SilentlyContinue -Force
}

if (-Not $backupLabel) {
    $backupLabel = Get-Date -Format "G"
    Write-Verbose -Message "Backup label not provided, setting it to $backupLabel"
}

$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

# retrieve the instance using the friendly name
if ($friendlyName) {
    $instance = Get-CrmInstances -ApiUrl $apiUrl -Credential $creds | ? {$_.FriendlyName -eq $friendlyName }
}
elif($uniqueName)
{
    # retrieve instance using the unique name
    $instance = Get-CrmInstances -ApiUrl $apiUrl -Credential $creds | ? {$_.UniqueName -eq $uniqueName }
}

$backupInfoRequest = New-CrmBackupInfo -InstanceId $instance.Id -Label $backupLabel -Notes $backupNotes

$backupJob = Backup-CrmInstance -ApiUrl $apiUrl -Credential $creds -BackupInfo $backupInfoRequest

Write-Host $backupJob.OperationId
Write-Host $backupJob.Status