<#
  .SYNOPSIS
    Recursively finds a list of files and uses a pattern to match and replace matches with a specified version number.
  .DESCRIPTION
    Recursively finds a list of files within a folder and uses a regular expression pattern to match and replace it with a specified version number.
	.NOTES
		Author: Shane Carvalho
		Version: generator-nullfactory-xrm@1.6.0
	.LINK
		https://nullfactory.net
	.PARAMETER BuildSourcePath
    The root folder to search.
  .PARAMETER versionFile
    The pattern of file to be searched.
  .PARAMETER regexPattern
    The regex pattern to be searched.
  .PARAMETER finalVersion
    The new version number.
  .PARAMETER encoding
    The optional encoding. Common encoding values include ASCII, Unicode, UTF8, Default. Default uses the encoding of the system's current ANSI code page.
  .EXAMPLE
    ReplaceVersion ".\SourceRootFolder" "*AssemblyInfo.cs" "\d+\.\d+\.\d+\.\d+" "1.3.0"
    Gets a list of all files starting with "*AssemblyInfo.cs" within the folder "SourceRootFolder". Within these files it attempts to match all instances of a version number ex. 0.0.0.0 and replace it with the new version number.
#>
function ReplaceVersion([string]$BuildSourcePath, [string] $versionFile, [string] $regexPattern, [string]$finalVersion, [string]$encoding='Default')
{
  [bool]$output = $false
  $files = Get-ChildItem $BuildSourcePath -recurse -include $versionFile

  if ($files)
  {
    $output = $true
    Write-Verbose "Attempting to apply $finalVersion to $($files.count) files in $BuildSourcePath\**\$versionFile ..."

    foreach ($file in $files)
    {
      $filecontent = Get-Content($file)
      attrib $file -r
      $filecontent -replace $regexPattern, $finalVersion | Out-File $file -encoding $encoding
      Write-Host "$finalVersion version successfully applied to $file with encoding $encoding" -ForegroundColor Green
    }
  }
  return $output
}

<#
  .SYNOPSIS
    Applies a specified version number to a list of file matching a pattern.
  .PARAMETER BuildSourcePath
    The root folder containing the source files.
  .PARAMETER BuildBuildNumber
    The new build number.
  .EXAMPLE
    ApplyVersionToAssemblies ".\RootFolder" "0.1.2"
#>
function ApplyVersionToAssemblies
{
  [CmdletBinding()]
  Param
  (
    [parameter(Position=0, Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$BuildSourcePath,
    [parameter(Position=1, Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$BuildBuildNumber
  )

  $isSuccess =  (ReplaceVersion $BuildSourcePath "*AssemblyInfo.cs" "\d+\.\d+\.\d+\.\d+" $BuildBuildNumber)

  if ($isSuccess)
  {
    Write-Warning "No files found at $BuildSourcePath."
  }
}

<#
  .SYNOPSIS
    Applies a specified version number to a CRM solution.
  .PARAMETER BuildSourcePath
    The root folder containing the extracted (via solutio packager) CRM Solution.
  .PARAMETER BuildBuildNumber
    The new build number.
  .EXAMPLE
    ApplyVersionToCrmSolution ".\RootFolder" "0.1.2"
#>
function ApplyVersionToCrmSolution
{
  [CmdletBinding()]
  Param
  (
    [parameter(Position=0, Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$BuildSourcePath,
    [parameter(Position=1, Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$BuildBuildNumber
  )

  $isSuccess = (ReplaceVersion $BuildSourcePath "Solution.xml" '<Version>[\s\S]*?<\/Version>' "<Version>$BuildBuildNumber</Version>" "utf8")

  if ($isSuccess -eq $false)
  {
    Write-Warning "No files found at $BuildSourcePath."
  }
}
