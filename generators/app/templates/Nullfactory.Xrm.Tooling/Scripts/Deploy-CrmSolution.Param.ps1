# Importing common functions
. .\CrmSolution.Common.ps1

Write-Host "Attempting to deploy solution(s)..."

.\Deploy-CrmSolution.ps1 `
  -serverUrl "<%= crmServerUrl %>" `
  -username (GetUsername "<%= crmSolutionName %>") `
  -password (GetPassword "<%= crmSolutionName %>") `
  -solutionName "<%= crmSolutionName %>" `
  -publishChanges `
  -activatePlugins

# Include new entry for each CRM solution to be released manually

# .\Deploy-CrmSolution.ps1 `
#   -serverUrl "http://servername/secondary" `
#   -username (GetUsername "env_secondary_username_key") `
#   -password (GetPassword "env_secondary_password_key") `
#   -solutionName "secondary" `
#   -publishChanges `
#   -activatePlugins

Write-Host "Deployment(s) complete." -ForegroundColor Green
