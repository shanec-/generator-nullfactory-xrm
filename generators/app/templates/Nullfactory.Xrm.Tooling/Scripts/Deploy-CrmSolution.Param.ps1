# Include new entry for each CRM solution to be released manually

.\Release-CrmSolution.ps1 `
-serverUrl "<%= crmServerUrl %>" `
-username "<%= crmUsername %>" `
-password "<%= crmPassword %>" `
-solutionName "<%= crmSolutionName %>" `
-publishChanges `
-activatePlugins