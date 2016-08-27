# Include new entry for each CRM solution to be synced to project

.\Sync-CrmSolution.ps1 `
-serverUrl "<%= crmServerUrl %>" `
-username "<%= crmUsername %>" `
-password "<%= crmPassword %>" `
-solutionName "<%= crmSolutionName %>" `
-solutionRootFolder "..\..\<%= visualStudioSolutionProjectPrefix %>.<%= crmSolutionName %>" `
-solutionMapFile "..\..\Nullfactory.Xrm.Tooling\Mappings\<%= crmSolutionName %>-mapping.xml"


#.\Sync-CrmSolution.ps1 `
#-serverUrl "http://servername/organizationname" `
#-username "domain\username" `
#-password "password" `
#-solutionName "solutionname" `
#-solutionRootFolder "..\..\Demo.Solutions.Primary"