<#

	.SYNOPSIS
		Deploy a CRM Solution to a remote server.
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
[CmdletBinding(DefaultParameterSetName="Internal")]
param(
	[Parameter(Mandatory=$true, Position=1)]
	[string]$serverUrl,
	[Parameter(Mandatory=$true, Position=2)]
	[string]$username,
	[Parameter(Mandatory=$true, Position=3)]
	[string]$password,
	[Parameter(ParameterSetName='Internal',Mandatory=$true, Position=4)]
	[string]$solutionName,
	[Parameter(ParameterSetName='Internal')]
	[switch]$deployManagedSolution,
	[Parameter(ParameterSetName='External',Mandatory=$true)]
	[string]$externalSolutionFileName,
	[Parameter(Mandatory=$false)]
	[switch]$isOnPremServer,
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

# if deploying external third party solution
if($externalSolutionFileName)
{
	$releaseZipFileName = Resolve-Path($externalSolutionFileName)
}
else
{
	if (-Not $deployManagedSolution){ $releaseZipFileName = Resolve-Path("..\..\$solutionName\*\*\$solutionName.zip") }
	else { $releaseZipFileName = Resolve-Path("..\..\$solutionName\*\*\$solutionName" + "_managed.zip") }
}

Write-Verbose "Importing the $releaseZipFileName solution into $serverUrl ..."
Import-CrmSolution `
	-SolutionFilePath $releaseZipFileName `
	-PublishChanges:$publishChanges `
	-ActivatePlugIns:$activatePlugIns `
	-ImportAsHoldingSolution:$importAsHoldingSolution `
	-MaxWaitTimeInSeconds 900
