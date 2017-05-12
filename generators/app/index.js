'use strict';
var yeoman = require('yeoman-generator');
var chalk = require('chalk');
var yosay = require('yosay');

module.exports = yeoman.Base.extend({
  prompting: function () {
    // Have Yeoman greet the user.
    this.log(yosay(
      'Welcome to ' + chalk.red('nullfactory-xrm') + '\n The Dynamics CRM/365 Project Structure Generator!'
    ));

    var prompts = [{
      type: 'input',
      name: 'visualStudioSolutionName',
      message: 'Visual Studio solution filename?',
      default: 'Nullfactory'
    },
    {
      type: 'input',
      name: 'visualStudioSolutionProjectPrefix',
      message: 'Visual Studio solution project filename prefix?',
      default: 'Nullfactory'
    },
    {
      type: 'input',
      name: 'crmServerUrl',
      message: 'Source CRM server url?',
      default: 'https://sandbox.crm6.dynamics.com/'
    },
    {
      type: 'input',
      name: 'crmSolutionName',
      message: 'Source CRM solution name?',
      default: 'solution1'
    },
    {
      type: 'confirm',
      name: 'isAddWebResourceProject',
      message: 'Add *.WebResource project?',
      default: true
    },
    {
      type: 'confirm',
      name: 'isAddPluginProject',
      message: 'Add *.Plugin project?',
      default: true
    },
    {
      type: 'confirm',
      name: 'isAddWorkflowProject',
      message: 'Add *.Workflow project?',
      default: true
    }];

    return this.prompt(prompts).then(function (props) {
      // To access props later use this.props.someAnswer;
      this.props = props;
    }.bind(this));
  },

  writing: function () {
    // intialize the tooling project
    this._writeToolingProject();

    // initialize the visual studio solution project
    this._writeVsSolutionProject();

    // initialize the crm solution project
    this._writeCrmSolutionProject();

    // add the web resource project
    if (this.props.isAddWebResourceProject) {
      this._writeResourcesProject();
    }

    // add the plugin project
    if (this.props.isAddPluginProject) {
      this._writePluginProject();
    }

    // add the workflow project
    if (this.props.isAddWorkflowProject) {
      this._writeWorkflowProject();
    }
  },

  // vs solution
  _writeVsSolutionProject: function () {
    this.fs.copyTpl(
      this.templatePath('Nullfactory.Xrm.Template.sln'),
      this.destinationPath(this.props.visualStudioSolutionName + '.sln'), {
        visualStudioSolutionProjectPrefix: this.props.visualStudioSolutionProjectPrefix,
        crmSolutionName: this.props.crmSolutionName,
        isAddPluginProject: this.props.isAddPluginProject,
        isAddWebResourceProject: this.props.isAddWebResourceProject,
        isAddWorkflowProject: this.props.isAddWorkflowProject
      }
    );

    this.fs.copyTpl(
      this.templatePath('README.md'),
      this.destinationPath('README.md'), {
        crmSolutionName: this.props.crmSolutionName,
        visualStudioSolutionProjectPrefix: this.props.visualStudioSolutionProjectPrefix,
        visualStudioSolutionName: this.props.visualStudioSolutionName,
        crmServerUrl: this.props.crmServerUrl
      }
    );
  },

  // crm solution
  _writeCrmSolutionProject: function () {
    var generatedSolutionName = this.props.visualStudioSolutionProjectPrefix + '.' + this.props.crmSolutionName;
    this.fs.copyTpl(
      this.templatePath('Project.Solution/Project.Solution.csproj'),
      this.destinationPath(generatedSolutionName + '/' + generatedSolutionName + '.csproj'), {
        crmSolutionName: this.props.crmSolutionName,
        visualStudioSolutionProjectPrefix: this.props.visualStudioSolutionProjectPrefix,
        visualStudioSolutionName: this.props.visualStudioSolutionName
      }
    );
  },

  // tooling project
  _writeToolingProject: function () {
    this.fs.copyTpl(
      this.templatePath('Nullfactory.Xrm.Tooling/Nullfactory.Xrm.Tooling.csproj'),
      this.destinationPath('Nullfactory.Xrm.Tooling/Nullfactory.Xrm.Tooling.csproj'), {
        crmSolutionName: this.props.crmSolutionName
      }
    );

    this.fs.copy(
      this.templatePath('Nullfactory.Xrm.Tooling/packages.config'),
      this.destinationPath('Nullfactory.Xrm.Tooling/packages.config')
    );

    this.fs.copy(
      this.templatePath('Nullfactory.Xrm.Tooling/_Install/Install-Microsoft.Xrm.Data.PowerShell.ps1'),
      this.destinationPath('Nullfactory.Xrm.Tooling/_Install/Install-Microsoft.Xrm.Data.PowerShell.ps1')
    );

    this.fs.copyTpl(
      this.templatePath('Nullfactory.Xrm.Tooling/Mappings/solution-mapping.xml'),
      this.destinationPath('Nullfactory.Xrm.Tooling/Mappings/' + this.props.crmSolutionName + '-mapping.xml'), {
        visualStudioSolutionProjectPrefix: this.props.visualStudioSolutionProjectPrefix,
        isAddPluginProject: this.props.isAddPluginProject,
        isAddWorkflowProject: this.props.isAddWorkflowProject
      }
    );

    this.fs.copy(
      this.templatePath('Nullfactory.Xrm.Tooling/Scripts/ApplyVersionToArtifact.ps1'),
      this.destinationPath('Nullfactory.Xrm.Tooling/Scripts/ApplyVersionToArtifact.ps1')
    );

    this.fs.copy(
      this.templatePath('Nullfactory.Xrm.Tooling/Scripts/CrmSolution.Common.ps1'),
      this.destinationPath('Nullfactory.Xrm.Tooling/Scripts/CrmSolution.Common.ps1')
    );

    this.fs.copy(
      this.templatePath('Nullfactory.Xrm.Tooling/Scripts/Pull-CrmSolution.ps1'),
      this.destinationPath('Nullfactory.Xrm.Tooling/Scripts/Pull-CrmSolution.ps1')
    );

    this.fs.copyTpl(
      this.templatePath('Nullfactory.Xrm.Tooling/Scripts/Pull-CrmSolution.Param.ps1'),
      this.destinationPath('Nullfactory.Xrm.Tooling/Scripts/Pull-CrmSolution.Param.ps1'), {
        visualStudioSolutionProjectPrefix: this.props.visualStudioSolutionProjectPrefix,
        crmSolutionName: this.props.crmSolutionName,
        crmServerUrl: this.props.crmServerUrl
      }
    );

    this.fs.copy(
      this.templatePath('Nullfactory.Xrm.Tooling/Scripts/Deploy-CrmSolution.ps1'),
      this.destinationPath('Nullfactory.Xrm.Tooling/Scripts/Deploy-CrmSolution.ps1')
    );

    this.fs.copyTpl(
      this.templatePath('Nullfactory.Xrm.Tooling/Scripts/Deploy-CrmSolution.Param.ps1'),
      this.destinationPath('Nullfactory.Xrm.Tooling/Scripts/Deploy-CrmSolution.Param.ps1'), {
        visualStudioSolutionProjectPrefix: this.props.visualStudioSolutionProjectPrefix,
        crmSolutionName: this.props.crmSolutionName,
        crmServerUrl: this.props.crmServerUrl
      }
    );
  },

  _writePluginProject: function () {
    var pluginProjectName = this.props.visualStudioSolutionProjectPrefix + '.Xrm.Plugins';
    this.fs.copyTpl(
      this.templatePath('Project.Xrm.Plugins/Project.Xrm.Plugins.csproj'),
      this.destinationPath(pluginProjectName + '/' + pluginProjectName + '.csproj'), {
        pluginProjectName: pluginProjectName
      }
    );

    this.fs.copyTpl(
      this.templatePath('Project.Xrm.Plugins/Properties/AssemblyInfo.cs'),
      this.destinationPath(pluginProjectName + '/Properties/AssemblyInfo.cs'), {
        pluginProjectName: pluginProjectName
      }
    );

    this.fs.copyTpl(
      this.templatePath('Project.Xrm.Plugins/SimplePlugin.cs'),
      this.destinationPath(pluginProjectName + '/SimplePlugin.cs'), {
        pluginProjectName: pluginProjectName
      }
    );

    this.fs.copy(
      this.templatePath('Project.Xrm.Plugins/packages.config'),
      this.destinationPath(pluginProjectName + '/packages.config')
    );
  },

  _writeWorkflowProject: function () {
    var workflowProjectName = this.props.visualStudioSolutionProjectPrefix + '.Xrm.Workflows';
    this.fs.copyTpl(
      this.templatePath('Project.Xrm.Workflows/Project.Xrm.Workflows.csproj'),
      this.destinationPath(workflowProjectName + '/' + workflowProjectName + '.csproj'), {
        workflowProjectName: workflowProjectName
      }
    );

    this.fs.copyTpl(
      this.templatePath('Project.Xrm.Workflows/Properties/AssemblyInfo.cs'),
      this.destinationPath(workflowProjectName + '/Properties/AssemblyInfo.cs'), {
        workflowProjectName: workflowProjectName
      }
    );

    this.fs.copyTpl(
      this.templatePath('Project.Xrm.Workflows/SimpleWorkflowActivity.cs'),
      this.destinationPath(workflowProjectName + '/SimpleWorkflowActivity.cs'), {
        workflowProjectName: workflowProjectName
      }
    );

    this.fs.copy(
      this.templatePath('Project.Xrm.Workflows/packages.config'),
      this.destinationPath(workflowProjectName + '/packages.config')
    );
  },

  _writeResourcesProject: function () {
    var generatedProjectName = this.props.visualStudioSolutionProjectPrefix + '.' + this.props.crmSolutionName + '.WebResources';
    this.fs.copyTpl(
      this.templatePath('Project.Solution.WebResources/Project.Solution.WebResources.csproj'),
      this.destinationPath(generatedProjectName + '/' + generatedProjectName + '.csproj'), {
        visualStudioSolutionProjectPrefix: this.props.visualStudioSolutionProjectPrefix,
        crmSolutionName: this.props.crmSolutionName
      }
    );
  },

  install: function () {
    // this.installDependencies();
  },

  end: function () {
    var postInstallSteps =
      chalk.green.bold('\nSuccessfully generated project structure for ' + this.props.crmSolutionName + '.') +
      '\n\nFinalize the installation by: \n   1. Running the following command in the Visual Studio' + chalk.yellow(' "Package Manager Console"') + ' window.\n\t' +
      chalk.yellow.bold('Update-Package -reinstall -project "Nullfactory.Xrm.Tooling"') +
      '\n';

    postInstallSteps += '   2. Download and extracting the remote CRM solution by executing the ' +
      chalk.yellow.bold('Pull-CrmSolution.Param.ps1') +
      ' powershell script.';

    if (this.props.isAddPluginProject || this.props.isAddWorkflowProject) {
      postInstallSteps += '\n   3. Add a strong name key file to the plugin and/or workflow projects.';
    }

    postInstallSteps += '\n\nPlease submit any issues found to ' + chalk.yellow.bold('https://github.com/shanec-/generator-nullfactory-xrm/issues');
    postInstallSteps += '\nGPL-3.0 © Shane Carvalho \n\n';

    this.log(postInstallSteps);
  }
});
///
