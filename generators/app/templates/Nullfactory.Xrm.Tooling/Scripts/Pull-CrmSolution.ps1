#
# Pull-CrmSolution.ps1
#
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
