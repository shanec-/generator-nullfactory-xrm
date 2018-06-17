'use strict';
const path = require('path');
const assert = require('yeoman-assert');
const helpers = require('yeoman-test');

describe('generator-nullfactory-xrm:tooling', () => {
  beforeAll(() => {
    return helpers.run(path.join(__dirname, '../generators/tooling')).withPrompts({
      isToolingUpgrade: true
    });
  });

  it('creates files', () => {
    assert.file([
      'Nullfactory.Xrm.Tooling/packages.config',
      'Nullfactory.Xrm.Tooling/_Install/Install-Microsoft.Xrm.Data.PowerShell.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/ApplyVersionToArtifact.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/CrmSolution.Common.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/Pull-CrmSolution.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/Deploy-CrmSolution.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Backup-CrmInstance.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Create-CrmInstance.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/CrmInstance.Common.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Delete-CrmInstance.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Get-AvailableCrmInstances.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Get-AvailableCrmTemplates.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Restore-CrmInstance.ps1'
    ]);

    assert.noFile([
      'Nullfactory.Xrm.Tooling/Nullfactory.Xrm.Tooling.csproj',
      'Nullfactory.Xrm.Tooling/Scripts/Pull-CrmSolution.Param.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/Deploy-CrmSolution.Param.ps1'
    ]);
  });
});

describe('generator-nullfactory-xrm:tooling no upgrade', () => {
  beforeAll(() => {
    return helpers.run(path.join(__dirname, '../generators/tooling')).withPrompts({
      isToolingUpgrade: false
    });
  });

  it('creates no files', () => {
    assert.noFile([
      'Nullfactory.Xrm.Tooling/packages.config',
      'Nullfactory.Xrm.Tooling/_Install/Install-Microsoft.Xrm.Data.PowerShell.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/ApplyVersionToArtifact.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/CrmSolution.Common.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/Pull-CrmSolution.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/Deploy-CrmSolution.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Backup-CrmInstance.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Create-CrmInstance.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/CrmInstance.Common.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Delete-CrmInstance.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Get-AvailableCrmInstances.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Get-AvailableCrmTemplates.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/omapi/Restore-CrmInstance.ps1',
      'Nullfactory.Xrm.Tooling/Nullfactory.Xrm.Tooling.csproj',
      'Nullfactory.Xrm.Tooling/Scripts/Pull-CrmSolution.Param.ps1',
      'Nullfactory.Xrm.Tooling/Scripts/Deploy-CrmSolution.Param.ps1'
    ]);
  });
});
