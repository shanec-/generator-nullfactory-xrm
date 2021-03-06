'use strict';
const path = require('path');
const assert = require('yeoman-assert');
const helpers = require('yeoman-test');

describe('generator-nullfactory-xrm:app', () => {
  beforeAll(() => {
    return helpers.run(path.join(__dirname, '../generators/app')).withPrompts({
      visualStudioSolutionName: 'TestSolution',
      visualStudioSolutionProjectPrefix: 'Test',
      crmServerUrl: 'https://sndbx.crm6.dynamics.com',
      crmSolutionName: 'FirstSolution',
      isAddWebResourceProject: true,
      isAddPluginProject: true,
      isAddWorkflowProject: true
    });
  });

  it('creates all files', () => {
    assert.file([
      'Nullfactory.Xrm.Tooling/Nullfactory.Xrm.Tooling.csproj',
      'Nullfactory.Xrm.Tooling/packages.config',
      'Nullfactory.Xrm.Tooling/_Install/Install-Microsoft.Xrm.Data.PowerShell.ps1',
      'Nullfactory.Xrm.Tooling/Mappings/FirstSolution-mapping.xml',
      'Nullfactory.Xrm.Tooling/Scripts/ApplyVersionToArtifact.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/CrmSolution.Common.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/Pull-CrmSolution.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/Pull-CrmSolution.Param.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/Deploy-CrmSolution.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/Deploy-CrmSolution.Param.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Backup-CrmInstance.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Create-CrmInstance.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/CrmInstance.Common.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Delete-CrmInstance.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Get-AvailableCrmInstances.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Get-AvailableCrmTemplates.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Restore-CrmInstance.ps1',
      '_RunFirst.ps1',
      'TestSolution.sln',
      'Test.FirstSolution/Test.FirstSolution.csproj',
      'Test.FirstSolution.WebResources/Test.FirstSolution.WebResources.csproj',
      'Test.Xrm.Plugins/Test.Xrm.Plugins.csproj',
      'Test.Xrm.Plugins/Properties/AssemblyInfo.cs',
      'Test.Xrm.Plugins/SimplePlugin.cs',
      'Test.Xrm.Plugins/packages.config',
      'Test.Xrm.Workflows/Test.Xrm.Workflows.csproj',
      'Test.Xrm.Workflows/Properties/AssemblyInfo.cs',
      'Test.Xrm.Workflows/SimpleWorkflowActivity.cs',
      'Test.Xrm.Workflows/packages.config'
    ]);
  });
});

describe('generator-nullfactory-xrm:app Without WebResources, Plugins and Workflow Projects', () => {
  beforeAll(() => {
    return helpers.run(path.join(__dirname, '../generators/app')).withPrompts({
      visualStudioSolutionName: 'TestSolution',
      visualStudioSolutionProjectPrefix: 'Test',
      crmServerUrl: 'https://sndbx.crm6.dynamics.com',
      crmSolutionName: 'FirstSolution',
      isAddWebResourceProject: false,
      isAddPluginProject: false,
      isAddWorkflowProject: false
    });
  });

  it('creates files', () => {
    assert.file([
      'Nullfactory.Xrm.Tooling/Nullfactory.Xrm.Tooling.csproj',
      'Nullfactory.Xrm.Tooling/packages.config',
      'Nullfactory.Xrm.Tooling/_Install/Install-Microsoft.Xrm.Data.PowerShell.ps1',
      'Nullfactory.Xrm.Tooling/Mappings/FirstSolution-mapping.xml',
      'Nullfactory.Xrm.Tooling/Scripts/ApplyVersionToArtifact.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/CrmSolution.Common.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/Pull-CrmSolution.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/Pull-CrmSolution.Param.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/Deploy-CrmSolution.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/Deploy-CrmSolution.Param.ps1',
      'TestSolution.sln',
      'Test.FirstSolution/Test.FirstSolution.csproj'
    ]);

    assert.noFile([
      'Test.FirstSolution.WebResources/Test.FirstSolution.WebResources.csproj',
      'Test.Xrm.Plugins/Test.Xrm.Plugins.csproj',
      'Test.Xrm.Plugins/Properties/AssemblyInfo.cs',
      'Test.Xrm.Plugins/SimplePlugin.cs',
      'Test.Xrm.Plugins/packages.config',
      'Test.Xrm.Workflows/Test.Xrm.Workflows.csproj',
      'Test.Xrm.Workflows/Properties/AssemblyInfo.cs',
      'Test.Xrm.Workflows/SimpleWorkflowActivity.cs',
      'Test.Xrm.Workflows/packages.config'
    ]);
  });
});
