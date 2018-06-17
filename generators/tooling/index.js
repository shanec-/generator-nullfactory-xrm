'use strict';
const Generator = require('yeoman-generator');
const prompt = require('./../app/prompt');
const utility = require('./../app/utility');

module.exports = class extends Generator {
  constructor(args, opts) {
    super(args, opts);

    this.argument('crmSolutionName', { required: false });
    this.argument('visualStudioSolutionProjectPrefix', { required: false });
    this.argument('crmServerUrl', { required: false });
    this.argument('isAddPluginProject', { required: false });
    this.argument('isAddWorkflowProject', { required: false });
    this.option('nosplash', { required: false, default: false });
    this.option('isIntegratedExecution', { required: false, default: false });

    this.crmSolutionName = this.options.crmSolutionName;
    this.visualStudioSolutionProjectPrefix = this.options.visualStudioSolutionProjectPrefix;
    this.crmServerUrl = this.options.crmServerUrl;
    this.isAddPluginProject = this.options.isAddPluginProject;
    this.isAddWorkflowProject = this.options.isAddWorkflowProject;
    this.noSplash = this.options.nosplash;
    this.isIntegratedExecution = this.options.isIntegratedExecution;
  }

  prompting() {
    utility.showSplash(this);

    var prompts = [prompt.isToolingUpgrade(this)];

    return this.prompt(prompts).then(props => {
      this.isToolingUpgrade = utility.resolveParameter(
        this.isToolingUpgrade,
        props.isToolingUpgrade
      );
    });
  }

  writing() {
    // Write the tooling project
    if (this.isIntegratedExecution) {
      this._writeToolingStaticFiles();
      this._writeToolingProject();
    } else if (this.isToolingUpgrade) {
      // Upgrade should only focus on the static files
      this._writeToolingStaticFiles();
    }
  }

  _writeToolingStaticFiles() {
    var staticFiles = [
      '_RunFirst.ps1',
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
    ];

    // Process static files that do no need parameters
    for (var i = 0; i < staticFiles.length; i++) {
      var element = staticFiles[i];
      /// this.log(element);
      this.fs.copy(this.templatePath(element), this.destinationPath(element));
    }
  }

  _writeToolingProject() {
    this.fs.copyTpl(
      this.templatePath('Nullfactory.Xrm.Tooling/Nullfactory.Xrm.Tooling.csproj'),
      this.destinationPath('Nullfactory.Xrm.Tooling/Nullfactory.Xrm.Tooling.csproj'),
      {
        crmSolutionName: this.crmSolutionName
      }
    );

    this.fs.copyTpl(
      this.templatePath('Nullfactory.Xrm.Tooling/Mappings/solution-mapping.xml'),
      this.destinationPath(
        'Nullfactory.Xrm.Tooling/Mappings/' + this.crmSolutionName + '-mapping.xml'
      ),
      {
        visualStudioSolutionProjectPrefix: this.visualStudioSolutionProjectPrefix,
        isAddPluginProject: this.isAddPluginProject,
        isAddWorkflowProject: this.isAddWorkflowProject
      }
    );

    this.fs.copyTpl(
      this.templatePath('Nullfactory.Xrm.Tooling/Scripts/Pull-CrmSolution.Param.ps1'),
      this.destinationPath('Nullfactory.Xrm.Tooling/Scripts/Pull-CrmSolution.Param.ps1'),
      {
        visualStudioSolutionProjectPrefix: this.visualStudioSolutionProjectPrefix,
        crmSolutionName: this.crmSolutionName,
        crmServerUrl: this.crmServerUrl
      }
    );

    this.fs.copyTpl(
      this.templatePath('Nullfactory.Xrm.Tooling/Scripts/Deploy-CrmSolution.Param.ps1'),
      this.destinationPath(
        'Nullfactory.Xrm.Tooling/Scripts/Deploy-CrmSolution.Param.ps1'
      ),
      {
        visualStudioSolutionProjectPrefix: this.visualStudioSolutionProjectPrefix,
        crmSolutionName: this.crmSolutionName,
        crmServerUrl: this.crmServerUrl
      }
    );
  }

  install() {}

  end() {
    utility.showInstructionsTooling(this);
  }
};
