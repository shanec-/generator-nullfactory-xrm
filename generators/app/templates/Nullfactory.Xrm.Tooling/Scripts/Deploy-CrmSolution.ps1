#
# Deploy-CrmSolution.ps1
#
param(
	[Parameter(Mandatory=$true, Position=1)]
	[string]$serverUrl,
	[Parameter(Mandatory=$true, Position=2)]
	[string]$username,
	[Parameter(Mandatory=$true, Position=3)]
	[string]$password,
	[Parameter(Mandatory=$true, Position=4)]
	[string]$solutionName,
	[Parameter(Mandatory=$false)]
	[switch]$isOnPremServer,
	[Parameter(Mandatory=$false)]
	[switch]$deployManagedSolution,
	[Parameter(Mandatory=$false)]
	[switch]$activatePlugIns,
	[Parameter(Mandatory=$false)]
	[switch]$publishChanges,
	[Parameter(Mandatory=$false)]
	[switch]$importAsHoldingSolution
)

if (-Not (Get-Module -ListAvailable -Name Microsoft.Xrm.Data.PowerShell))
{
  Write-Verbose "Initializing Micrsoft.Xrm.Data.Powershell module ..."
  Install-Module -Name Microsoft.Xrm.Data.PowerShell -Scope CurrentUser -ErrorAction SilentlyContinue -Force
}

$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

if($isOnPremServer)
{
	Write-Verbose "Connecting to OnPrem CRM instance $serverUrl ..."
	$connectionState = Connect-CrmOnPremDiscovery -Credential $creds -ServerUrl $serverUrl
}
else
{
	Write-Verbose "Connecting to Online CRM instance $serverUrl ..."
	$connectionState = Connect-CrmOnline -Credential $creds -ServerUrl $serverUrl
}

# Make sure that the connection was successful, else stop the script.
if($connectionState.IsReady -eq $false)
{
	throw $connectionState.LastCrmError
}

$releaseZipFileName = "";

if (-Not $deployManagedSolution){ $releaseZipFileName = Resolve-Path("..\..\$solutionName\*\*\$solutionName.zip") }
else { $releaseZipFileName = Resolve-Path("..\..\$solutionName\*\*\$solutionName" + "_managed.zip") }

Write-Verbose "Importing the $releaseZipFileName solution into $serverUrl ..."
Import-CrmSolution `
	-SolutionFilePath $releaseZipFileName `
	-PublishChanges:$publishChanges `
	-ActivatePlugIns:$activatePlugIns `
	-ImportAsHoldingSolution:$importAsHoldingSolution `
	-MaxWaitTimeInSeconds 900
