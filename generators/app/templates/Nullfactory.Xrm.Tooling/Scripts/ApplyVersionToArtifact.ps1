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
      $filecontent -replace $regexPattern, $finalVersion | Out-File $file
      Write-Host "$finalVersion version successfully applied to $file with encoding $encoding" -ForegroundColor Green
    }
  }
  return $output
}

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
    [string]$BuildBuildNumber,
    [parameter(Position=3, Mandatory=$false)]
    [string]$regEx = ''
  )

  if ([string]::IsNullOrWhiteSpace($regEx))
  {
    $regEx = "\d+\.\d+\.\d+\.\d+"
  }

  $isSuccess =  (ReplaceVersion $BuildSourcePath "*AssemblyInfo.cs" $regEx $BuildBuildNumber)

  if ($isSuccess)
  {
    Write-Warning "No files found at $BuildSourcePath."
  }
}

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
