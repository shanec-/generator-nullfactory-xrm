<#
  .SYNOPSIS
    Generate Xrm Early Bound Classes.
  .DESCRIPTION
    Generate Xrm Early Bound Classes.
	.NOTES
		Author: Shane Carvalho
		Version: generator-nullfactory-xrm@1.7.1
	.LINK
		https://nullfactory.net
#>

# Importing common functions
. .\CrmSolution.Common.ps1

# Defaulting to increased verbosity for manual execution
$oldverbose = $VerbosePreference
$VerbosePreference = "continue"

Write-Host "Attempting to generate early bound classes ..."
Write-Warning "Adjust path to suit your project"
try
{
  .\New-EarlyBoundClasses.ps1 `
    -serverUrl "<%= crmServerUrl %>" `
    -username (Get-CrmUsername "<%= visualStudioSolutionProjectPrefix %>.<%= crmSolutionName %>") `
    -password (Get-CrmPassword "<%= visualStudioSolutionProjectPrefix %>.<%= crmSolutionName %>") `
    -namespace "<%= visualStudioSolutionProjectPrefix %>" `
    -outPath "..\..\Xrm.cs"

  Write-Host "Early bound classes generated successfully." -ForegroundColor Green
}
finally
{
	# Reset the verbosity to original level
	$VerbosePreference = $oldverbose
}
