
function GetUsername($solutionName)
{
  $variableName = "nfac_" + $solutionName + "_username"
  $username = [environment]::GetEnvironmentVariable($variableName, "User")

  if($username -eq $null)
  {
    $username = Read-Host "Set username for $solutionName"
    [environment]::SetEnvironmentVariable($variableName, $username,  "User")
  }
  return $username;
}

function GetPassword($solutionName)
{
  $variableName = "nfac_" + $solutionName + "_password"
  $plainTextPassword = [environment]::GetEnvironmentVariable($variableName, "User")

  if($plainTextPassword -eq $null)
  {
    $securePassword = Read-Host "Set password for $solutionName" -AsSecureString
    $plainTextPassword = (New-Object PSCredential "user", $SecurePassword).GetNetworkCredential().Password
    [environment]::SetEnvironmentVariable($variableName, $plainTextPassword,  "User")
  }
  return $plainTextPassword;
}

.\Sync-CrmSolution.ps1 `
  -serverUrl "<%= crmServerUrl %>" `
  -username (GetUsername "<%= crmSolutionName %>") `
  -password (GetPassword "<%= crmSolutionName %>") `
  -solutionName "<%= crmSolutionName %>" `
  -solutionRootFolder "..\..\<%= visualStudioSolutionProjectPrefix %>.<%= crmSolutionName %>" `
  -solutionMapFile "..\..\Nullfactory.Xrm.Tooling\Mappings\<%= crmSolutionName %>-mapping.xml"

# Include a new entry for each CRM solution to be synced against a project folder

# .\Sync-CrmSolution.ps1 `
#   -serverUrl "http://servername/secondary" `
#   -username (GetUsername "env_secondary_username_key") `
#   -password (GetPassword "env_secondary_password_key") `
#   -solutionName "secondary" `
#   -solutionRootFolder "..\..\Demo.Solutions.Secondary" `
#   -solutionMapFile "..\..\Nullfactory.Xrm.Tooling\Mappings\secondary-mapping.xml"
