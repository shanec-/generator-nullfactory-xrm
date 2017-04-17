<#
  .SYNOPSIS
    Retrieves the username for the specified CRM solution.
  .DESCRIPTION
    Retrieves the username for the specified CRM solution which is stored in a user-environmental variable. If one does not exist, the script would prompt the user for a new username, which is then stored in a new environment variable.
	.NOTES
		Author: Shane Carvalho
		Version: generator-nullfactory-xrm@1.4.0
	.LINK
		https://nullfactory.net
	.PARAMETER solutionName
    The name of the CRM solution.
  .EXAMPLE
    $username = Get-CrmUsername("Nullfactory.Solution1")
#>
function Get-CrmUsername($solutionName)
{
  $variableName = "nfac_" + $solutionName + "_username"
  $username = [environment]::GetEnvironmentVariable($variableName, "User")

  if($username -eq $null)
  {
    Write-Host "Please provide the username to access $solutionName. It will be saved as [$variableName] user environmental variable." -ForegroundColor Yellow
    $username = Read-Host "Username"
    [environment]::SetEnvironmentVariable($variableName, $username,  "User")
  }
  return $username;
}

<#
  .SYNOPSIS
    Retrieves the password for the specified CRM solution.
  .DESCRIPTION
    Retrieves the password for the specified CRM solution which is stored in a user-environmental variable. If one does not exist, the script would prompt the user for a new password, which is then stored in a new environment variable.
    Note that the password is stored as plain-text.
  .PARAMETER solutionName
    The name of the CRM solution.
  .EXAMPLE
    $username = Get-CrmPassword("Nullfactory.Solution1")
#>
function Get-CrmPassword($solutionName)
{
  $variableName = "nfac_" + $solutionName + "_password"
  $plainTextPassword = [environment]::GetEnvironmentVariable($variableName, "User")

  if($plainTextPassword -eq $null)
  {
    $securePassword = Read-Host "Password" -AsSecureString
    $plainTextPassword = (New-Object PSCredential "user", $SecurePassword).GetNetworkCredential().Password
    [environment]::SetEnvironmentVariable($variableName, $plainTextPassword,  "User")
  }
  return $plainTextPassword;
}
