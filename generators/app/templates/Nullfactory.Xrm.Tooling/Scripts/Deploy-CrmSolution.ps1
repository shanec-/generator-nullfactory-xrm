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
    [switch]$deployManagedSolution,
    [Parameter(Mandatory=$false)]
    [switch]$activatePlugIns,
	[Parameter(Mandatory=$false)]
	[switch]$publishChanges
)

Write-Verbose "Import Micrsoft.Xrm.Data.Powershell module"
Import-Module Microsoft.Xrm.Data.Powershell

$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

Write-Verbose "Connecting to the crm instance $serverUrl ..."
Connect-CrmOnPremDiscovery -Credential $creds -ServerUrl $serverUrl

$releaseZipFileName = "";

if (-Not $deployManagedSolution){ $releaseZipFileName = Resolve-Path(".\$solutionName.zip") } 
else { $releaseZipFileName = Resolve-Path(".\$solutionName_managed.zip") }

Write-Verbose "Importing the $releaseZipFileName solution..."
Import-CrmSolution -SolutionFilePath $releaseZipFileName -PublishChanges $publishChanges -ActivatePlugIns $activatePlugIns