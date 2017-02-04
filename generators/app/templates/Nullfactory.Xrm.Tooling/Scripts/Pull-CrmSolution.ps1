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
	Connect-CrmOnPremDiscovery -Credential $creds -ServerUrl $serverUrl
}
else
{
	Write-Verbose "Connecting to the Online crm instance $serverUrl ..."
	Connect-CrmOnline -Credential $creds -ServerUrl $serverUrl
}

$exportZipFileName = $solutionName + "_export.zip"
$exportZipFileNameManaged = $solutionName + "_export_Managed.zip"

if (Test-Path $exportZipFileName) { Remove-Item $exportZipFileName }
if (Test-Path $exportZipFileNameManaged) { Remove-Item $exportZipFileNameManaged }

Write-Verbose "Exporting the un-managed version of the solution..."
Export-CrmSolution -SolutionName $solutionName -SolutionZipFileName $exportZipFileName

Write-Verbose "Exporting the managed version of the solution..."
Export-CrmSolution -SolutionName $solutionName -Managed -SolutionZipFileName $exportZipFileNameManaged

Write-Verbose "Delete the source controlled artifacts while keeping the project file intact..."
Remove-Item -Recurse $solutionRootFolder  -Force -exclude *.csproj

Write-Verbose "Extracing previous generated solution..."
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
	Write-Verbose "using mapping file $solutionMapFile for packaging"
	.\..\bin\coretools\SolutionPackager.exe `
	/a:extract `
	/packagetype:both `
	/f:"$solutionRootFolder" `
	/z:"$exportZipFileName" `
	/ad:no `
	/map:"$solutionMapFile"
}
