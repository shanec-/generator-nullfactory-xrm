# Importing common functions
. .\CrmSolution.Common.ps1

Write-Host "Attempting to synchronize solution(s)..."

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

Write-Host "Synchronization complete." -ForegroundColor Green
