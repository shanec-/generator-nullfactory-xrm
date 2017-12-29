<#

	.SYNOPSIS
		Download a solution from a remote CRM server and extract to a specified folder location.
	.DESCRIPTION
		This scripts automatically connect to a remote dynamics CRM instance, downloads a specified CRM solution and unpacks it to the specified folder via the Solution Packager tool. Works with both on-premises and online solutions.

    Pre-requisites:
      - PowerShell V5 or greater
      - Latest version of Solution Packager tool provided with the CRM SDK.
      - Micrsoft.Xrm.Data.Powershell 2.4 or greater

	.NOTES
		Author: Shane Carvalho
		Version: generator-nullfactory-xrm@1.6.0
	.LINK
		https://nullfactory.net
	.PARAMETER serverUrl
		Required parameter that specifies the server url of the Dynamics CRM instance.
	.PARAMETER username
		Mandatory paramater is the username used to connect to Dynamics CRM.
	.PARAMETER password
		Mandatory paramerter is the password of the user used to connect to Dynamics CRM.
	.PARAMETER solutionName
		Required paramter. The name of the solution that needs to be downloaded and extracted.
	.PARAMETER solutionRootFolder
		Required Parameter. The folder into which the solution will be extracted to.
	.PARAMETER isOnPremServer
		This optional switch that tells the script if the server is an OnPremises server. CRM Online is the default provider.
	.PARAMETER solutionMapFile
		This is an option parameter that specifies the path of the maping file used to be used by SolutionPackager.
	.EXAMPLE
		.\Pull-CrmSolution.ps1 -serverUrl "https://sndbx.crm6.dynamics.com" -username "admin@sndx.onmicrosoft.com" -password "P@ssw0rd!" -solutionName "RemoteSolutionName" -solutionRootFolder ".\RemoteSolutionRoot"
		Download remote solution "RemoteSolutionName" from the "https://sndbx.crm6.dynamics.com" dynamics crm online server and extract it to the "RemoteSolutionRoot" folder.
	.EXAMPLE
		.\Pull-CrmSolution.ps1 -serverUrl "https://sndbx.crm6.dynamics.com" -username "admin@sndx.onmicrosoft.com" -password "P@ssw0rd!" -solutionName "RemoteSolutionName" -solutionRootFolder ".\RemoteSolutionRoot" -solutionMapFile ".\RemoteSolutionName-mapping.xml"
		Download remote solution "RemoteSolutionName" from the "https://sndbx.crm6.dynamics.com" dynamics crm online server and extract it to the "RemoteSolutionRoot" folder using the "RemoteSolutionName-mapping.xml" mapping file.
	.EXAMPLE
		.\Pull-CrmSolution.ps1 -serverUrl "https://onpremserver.local/orgname" -username "admin@local" -password "P@ssw0rd!" -solutionName "RemoteSolutionName" -solutionRootFolder ".\RemoteSolutionRoot" -isOnPremServer
		Download remote solution "RemoteSolutionName" from the "https://onpremserver/orgname" on premises server and extract it to the "RemoteSolutionRoot".

#>
param(
	[Parameter(Mandatory=$true)]
	[string]$serverUrl,
	[Parameter(Mandatory=$true)]
	[string]$username,
	[Parameter(Mandatory=$true)]
	[string]$password,
	[Parameter(Mandatory=$true)]
	[string]$solutionName,
	[Parameter(Mandatory=$true)]
	[string]$solutionRootFolder,
	[Parameter(Mandatory=$false)]
	[switch]$isOnPremServer,
	[Parameter(Mandatory=$false)]
	[string]$solutionMapFile = ""
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
	Write-Verbose "Connecting to the OnPrem crm instance $serverUrl ..."
	$connectionState = Connect-CrmOnPremDiscovery -Credential $creds -ServerUrl $serverUrl
}
else
{
	Write-Verbose "Connecting to the Online crm instance $serverUrl ..."
	$connectionState = Connect-CrmOnline -Credential $creds -ServerUrl $serverUrl
}

# Make sure that the connection was successful, else stop the script.
if($connectionState.IsReady -eq $false)
{
	throw $connectionState.LastCrmError
}

$exportZipFileName = $solutionName + "_export.zip"
$exportZipFileNameManaged = $solutionName + "_export_Managed.zip"

# Clear previous instances of the exported solution file
if (Test-Path $exportZipFileName) { Remove-Item $exportZipFileName }
if (Test-Path $exportZipFileNameManaged) { Remove-Item $exportZipFileNameManaged }

Write-Verbose "Exporting the un-managed version of the solution..."
Export-CrmSolution -SolutionName $solutionName -SolutionZipFileName $exportZipFileName

Write-Verbose "Exporting the managed version of the solution..."
Export-CrmSolution -SolutionName $solutionName -Managed -SolutionZipFileName $exportZipFileNameManaged

Write-Verbose "Delete the source controlled artifacts while keeping the project file intact..."
Remove-Item -Recurse $solutionRootFolder  -Force -exclude *.csproj

Write-Verbose "Unpacking exported solution..."
if($solutionMapFile -eq "")
{
	.\..\bin\coretools\SolutionPackager.exe `
	/a:extract `
	/packagetype:both `
	/f:"$solutionRootFolder" `
	/z:"$exportZipFileName" `
	/ad:no
}
else
{
	Write-Verbose "Using mapping file $solutionMapFile for unpacking"
	.\..\bin\coretools\SolutionPackager.exe `
	/a:extract `
	/packagetype:both `
	/f:"$solutionRootFolder" `
	/z:"$exportZipFileName" `
	/ad:no `
	/map:"$solutionMapFile"
}

# Verify that the solution packager ran successfully.
if($?)
{
	Write-Verbose "Unpack successful!"
}
else
{
	throw "SolutionPackager unpack failed."
}
