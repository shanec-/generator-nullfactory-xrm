# Include new entry for each CRM solution to be released manually

.\Deploy-CrmSolution.ps1 `
-serverUrl "<%= crmServerUrl %>" `
-username "<%= crmUsername %>" `
-password "<%= crmPassword %>" `
-solutionName "<%= visualStudioSolutionProjectPrefix %>.<%= crmSolutionName %>" `
-publishChanges `
-activatePlugins