<#

	.SYNOPSIS
		Backup a CRM instance.
	.DESCRIPTION
    This scripts automatically connect to a remote Dynamics CRM instance using the provided credentials and deploys the specified solution. Works with both on-premises and online solutions.

    Pre-requisites:
      - PowerShell V5 or greater
      - Latest version of Solution Packager tool provided with the CRM SDK.
      - Micrsoft.Xrm.Data.Powershell 2.4 or greater

	.NOTES
		Author: Shane Carvalho
		Version: generator-nullfactory-xrm@1.4.0
	.LINK
		https://nullfactory.net
	.PARAMETER serverUrl
		Mandatory parameter that specifies the server url of the Dynamics CRM instance being deployed to.
	.PARAMETER username
		Mandatory paramater is the username used to connect to Dynamics CRM.
	.PARAMETER password
		Mandatory paramerter is the password of the user used to connect to Dynamics CRM.
	.PARAMETER solutionName
		Required paramter. The name of the solution that needs to be downloaded and extracted.
	.PARAMETER isOnPremServer
		This optional switch tells the script if the server is an OnPremises server. CRM Online is the default provider.
	.PARAMETER deployManagedSolution
		This optional switch tells the script that it should deploy the managed version of the solution`. The unmanaged version is selected by default.
	.PARAMETER activatePlugIns
		This optional switch tells the script that it should attempt to activate plugins that have been included as part of the solution. Defaults to false.
	.PARAMETER publishChanges
		This optional switch tells the script that it should publish changes once deployed. Defaults to false.
	.PARAMETER importAsHoldingSolution
		This optional switch tells the script that it should import the solution as a hold solution.
	.EXAMPLE
		.\Deploy-CrmSolution.ps1 -serverUrl "https://sndbx.crm6.dynamics.com" -username "admin@sndx.onmicrosoft.com" -password "P@ssw0rd!" -solutionName "RemoteSolutionName"
		Deploys the unmanaged version of "RemoteSolutionName" to the "https://sndbx.crm6.dynamics.com" dynamics crm online server.
	.EXAMPLE
		.\Deploy-CrmSolution.ps1 -serverUrl "https://sndbx.crm6.dynamics.com" -username "admin@sndx.onmicrosoft.com" -password "P@ssw0rd!" -solutionName "RemoteSolutionName" -deployManagedSolution -isOnPremServer
		Deploys the managed version of "RemoteSolutionName" to the "https://sndbx.crm6.dynamics.com" dynamics crm on premises  server and extract it to the "RemoteSolutionRoot" folder using the "RemoteSolutionName-mapping.xml" mapping file.
	.EXAMPLE
		.\Deploy-CrmSolution.ps1 -serverUrl "https://onpremserver/orgname" -username "admin@sndx.onmicrosoft.com" -password "P@ssw0rd!" -solutionName "RemoteSolutionName" -isOnPremServer -activatePlugIns -publishChanges -importAsHoldingSolution
		Deploys the unmanaged version of "RemoteSolutionName" to the "https://onpremserver/orgname" dynamics crm onprem server as an holding solution. Once deployed, activate plugins and publish changes.
	.EXAMPLE
		.\Deploy-CrmSolution.ps1 -serverUrl "https://sndbx.crm6.dynamics.com" -username "admin@sndx.onmicrosoft.com" -password "P@ssw0rd!" -externalSolutionFileName ".\ThirdPartySolution.zip" -activatePlugIns -publishChanges
		Deploys "ThirdPartySolution.zip" solution to the "https://sndbx.crm6.dynamics.com" dynamics crm online. Once deployed, activate plugins and publish changes.

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
    [string]$uniqueName,
    [string]$backupLabel,
    [string]$backupNotes
)

# Importing common functions
. .\CrmInstance.Common.ps1
$creds = Init-OmapiModule $username $password

# if a backup label is not provided, generate one
if (-Not $backupLabel) {
    $backupLabel = Get-Date -Format "G"
    Write-Verbose -Message "Backup label not provided, defaulting to $backupLabel"
}

# if an instance id is not provided then attempt to use the aliases
if(-Not $instanceId)
{
    $instanceId = Get-CrmInstanceByName $apiUrl $creds $friendlyName $uniqueName
}

Write-Verbose "Resolved InstanceId: $instanceId"

$backupInfoRequest = New-CrmBackupInfo -InstanceId $instanceId -Label $backupLabel -Notes $backupNotes
$backupJob = Backup-CrmInstance -ApiUrl $apiUrl -Credential $creds -BackupInfo $backupInfoRequest

$backupOperationId = $backupJob.OperationId
$backupOperationStatus = $backupJob.Status

Write-Host "OperationId: $backupOperationId Status: $backupOperationStatus"

Wait-CrmOperation $apiUrl $creds $backupOperationId

Write-Host "Backup creation timed out."
exit 1
