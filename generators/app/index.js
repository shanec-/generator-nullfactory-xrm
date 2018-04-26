'use strict';
const Generator = require('yeoman-generator');
const utility = require('./utility');
const prompt = require('./prompt');

module.exports = class extends Generator {
  prompting() {
    // Have Yeoman greet the user.
    utility.showSplash(this);

    return this.prompt([
      prompt.visualStudioSolutionName(this),
      prompt.visualStudioSolutionProjectPrefix(this),
      prompt.crmServerUrl(this),
      prompt.crmSolutionName(this),
      prompt.isAddWebResourceProject(this),
      prompt.isAddPluginProject(this),
      prompt.isAddWorkflowProject(this)
    ]).then(props => {
      this.visualStudioSolutionName = props.visualStudioSolutionName;
      this.visualStudioSolutionProjectPrefix = props.visualStudioSolutionProjectPrefix;
      this.crmServerUrl = props.crmServerUrl;
      this.crmSolutionName = props.crmSolutionName;
      this.isAddWebResourceProject = props.isAddWebResourceProject;
      this.isAddPluginProject = props.isAddPluginProject;
      this.isAddWorkflowProject = props.isAddWorkflowProject;
    });
  }

  writing() {
    // Intialize the tooling project
    this._writeToolingProject();

    // Initialize the visual studio solution project
    this._writeVsSolutionProject();

    // Initialize the crm solution project
    this._writeCrmSolutionProject();

    // Add the web resource project
    if (this.isAddWebResourceProject) {
      this._writeResourcesProject();
    }

    // Add the plugin project
    if (this.isAddPluginProject) {
      this._writePluginProject();
    }

    // Add the workflow project
    if (this.isAddWorkflowProject) {
      this._writeWorkflowProject();
    }
  }

  // Vs solution
  _writeVsSolutionProject() {
    this.fs.copyTpl(
      this.templatePath('Nullfactory.Xrm.Template.sln'),
      this.destinationPath(this.visualStudioSolutionName + '.sln'),
      {
        visualStudioSolutionProjectPrefix: this.visualStudioSolutionProjectPrefix,
        crmSolutionName: this.crmSolutionName,
        isAddPluginProject: this.isAddPluginProject,
        isAddWebResourceProject: this.isAddWebResourceProject,
        isAddWorkflowProject: this.isAddWorkflowProject
      }
    );

    this.fs.copyTpl(this.templatePath('README.md'), this.destinationPath('README.md'), {
      crmSolutionName: this.crmSolutionName,
      visualStudioSolutionProjectPrefix: this.visualStudioSolutionProjectPrefix,
      visualStudioSolutionName: this.visualStudioSolutionName,
      crmServerUrl: this.crmServerUrl
    });
  }

  // Crm solution
  _writeCrmSolutionProject() {
    // Var generatedSolutionName =
    //   this.visualStudioSolutionProjectPrefix + '.' + this.crmSolutionName;
    // This.fs.copyTpl(
    //   this.templatePath('Project.Solution/Project.Solution.csproj'),
    //   this.destinationPath(
    //     generatedSolutionName + '/' + generatedSolutionName + '.csproj'
    //   ),
    //   {
    //     crmSolutionName: this.crmSolutionName,
    //     visualStudioSolutionProjectPrefix: this.visualStudioSolutionProjectPrefix,
    //     visualStudioSolutionName: this.visualStudioSolutionName
    //   }
    // );

    this.log('composeWith' + this.crmSolutionName);
    this.log(this.visualStudioSolutionProjectPrefix);
    this.log(this.visualStudioSolutionName);

    // This.composeWith(require.resolve('../solution'), {
    //   arguments: [
    //     this.crmSolutionName,
    //     this.visualStudioSolutionProjectPrefix,
    //     this.visualStudioSolutionName,
    //     'nosplash'
    //   ]
    // });

    this.composeWith('nullfactory-xrm:solution', {
      arguments: [
        this.crmSolutionName,
        this.visualStudioSolutionProjectPrefix,
        this.visualStudioSolutionName,
        'nosplash'
      ]
    });
  }

  // Tooling project
  _writeToolingProject() {
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

  _writePluginProject() {
    var pluginProjectName = this.visualStudioSolutionProjectPrefix + '.Xrm.Plugins';
    this.fs.copyTpl(
      this.templatePath('Project.Xrm.Plugins/Project.Xrm.Plugins.csproj'),
      this.destinationPath(pluginProjectName + '/' + pluginProjectName + '.csproj'),
      {
        pluginProjectName: pluginProjectName
      }
    );

    this.fs.copyTpl(
      this.templatePath('Project.Xrm.Plugins/Properties/AssemblyInfo.cs'),
      this.destinationPath(pluginProjectName + '/Properties/AssemblyInfo.cs'),
      {
        pluginProjectName: pluginProjectName
      }
    );

    this.fs.copyTpl(
      this.templatePath('Project.Xrm.Plugins/SimplePlugin.cs'),
      this.destinationPath(pluginProjectName + '/SimplePlugin.cs'),
      {
        pluginProjectName: pluginProjectName
      }
    );

    this.fs.copy(
      this.templatePath('Project.Xrm.Plugins/packages.config'),
      this.destinationPath(pluginProjectName + '/packages.config')
    );
  }

  _writeWorkflowProject() {
    var workflowProjectName = this.visualStudioSolutionProjectPrefix + '.Xrm.Workflows';
    this.fs.copyTpl(
      this.templatePath('Project.Xrm.Workflows/Project.Xrm.Workflows.csproj'),
      this.destinationPath(workflowProjectName + '/' + workflowProjectName + '.csproj'),
      {
        workflowProjectName: workflowProjectName
      }
    );

    this.fs.copyTpl(
      this.templatePath('Project.Xrm.Workflows/Properties/AssemblyInfo.cs'),
      this.destinationPath(workflowProjectName + '/Properties/AssemblyInfo.cs'),
      {
        workflowProjectName: workflowProjectName
      }
    );

    this.fs.copyTpl(
      this.templatePath('Project.Xrm.Workflows/SimpleWorkflowActivity.cs'),
      this.destinationPath(workflowProjectName + '/SimpleWorkflowActivity.cs'),
      {
        workflowProjectName: workflowProjectName
      }
    );

    this.fs.copy(
      this.templatePath('Project.Xrm.Workflows/packages.config'),
      this.destinationPath(workflowProjectName + '/packages.config')
    );
  }

  _writeResourcesProject() {
    var generatedProjectName =
      this.visualStudioSolutionProjectPrefix +
      '.' +
      this.crmSolutionName +
      '.WebResources';
    this.fs.copyTpl(
      this.templatePath(
        'Project.Solution.WebResources/Project.Solution.WebResources.csproj'
      ),
      this.destinationPath(generatedProjectName + '/' + generatedProjectName + '.csproj'),
      {
        visualStudioSolutionProjectPrefix: this.visualStudioSolutionProjectPrefix,
        crmSolutionName: this.crmSolutionName
      }
    );
  }

  install() {
    /// this.installDependencies();
  }

  end() {
    utility.showPostInstructions(this);
  }
};
