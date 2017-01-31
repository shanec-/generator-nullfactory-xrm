function GetUsername($solutionName)
{
  $variableName = "nfac_" + $solutionName + "_username"
  $username = [environment]::GetEnvironmentVariable($variableName, "User")

  if($username -eq $null)
  {
    Write-Host "Please provide the username to access $solutionName. It willl be saved in the [$variableName] user environmental variable." -ForegroundColor Yellow
    $username = Read-Host "Username"
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
    $securePassword = Read-Host "Password" -AsSecureString
    $plainTextPassword = (New-Object PSCredential "user", $SecurePassword).GetNetworkCredential().Password
    [environment]::SetEnvironmentVariable($variableName, $plainTextPassword,  "User")
  }
  return $plainTextPassword;
}
