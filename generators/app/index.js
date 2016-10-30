'use strict';
var yeoman = require('yeoman-generator');
var chalk = require('chalk');
var yosay = require('yosay');

module.exports = yeoman.Base.extend({
  prompting: function () {
    // Have Yeoman greet the user.
    this.log(yosay(
      'Welcome to the ' + chalk.red('nullfactory-xrm') + ' generator!'
    ));

    var prompts = [{
      type: 'input',
      name: 'visualStudioSolutionName',
      message: 'Visual Studio solution filename?',
      default: 'nullfactory'
    },
    {
      type: 'input',
      name: 'visualStudioSolutionProjectPrefix',
      message: 'Visual Studio solution project filename prefix?',
      default: 'nullfactory'
    },
    {
      type: 'input',
      name: 'crmServerUrl',
      message: 'Source CRM server url?',
      default: 'https://sandbox.crm6.dynamics.com/'
    },
    {
      type: 'input',
      name: 'crmUsername',
      message: 'Source CRM username?',
      default: 'admin@sandbox.onmicrosoft.com'
    },
    {
      type: 'input',
      name: 'crmPassword',
      message: 'Source CRM password?',
      default: 'P@ssw0rd'
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
      type:'confirm',
      name: 'isAddPluginProject',
      message: 'Add *.Plugin project?',
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

    if (this.props.isAddWebResourceProject) {
      this._writeResourcesProject();
    }

    if (this.props.isAddPluginProject) {
      this._writePluginProject();
    }
  },

 // vs solution
  _writeVsSolutionProject : function () {
    this.fs.copyTpl(
      this.templatePath('Nullfactory.Xrm.Template.sln'),
      this.destinationPath(this.props.visualStudioSolutionName + '.sln'), {
        visualStudioSolutionProjectPrefix: this.props.visualStudioSolutionProjectPrefix,
        crmSolutionName: this.props.crmSolutionName,
        isAddPluginProject: this.props.isAddPluginProject,
        isAddWebResourceProject: this.props.isAddWebResourceProject
      }
    );
  },

  // crm solution
  _writeCrmSolutionProject: function () {
    var generatedSolutionName = this.props.visualStudioSolutionProjectPrefix + '.' + this.props.crmSolutionName;
    this.fs.copyTpl(
      this.templatePath('Project.Solution/Project.Solution.csproj'),
      this.destinationPath(generatedSolutionName + '/'+ generatedSolutionName +'.csproj'), {
          crmSolutionName: this.props.crmSolutionName,
          visualStudioSolutionProjectPrefix: this.props.visualStudioSolutionProjectPrefix,
          visualStudioSolutionName : this.props.visualStudioSolutionName
      }
    );
  },

  // tooling project
  _writeToolingProject: function (){
      this.fs.copyTpl(
        this.templatePath('Nullfactory.Xrm.Tooling/Nullfactory.Xrm.Tooling.csproj'),
        this.destinationPath('Nullfactory.Xrm.Tooling/Nullfactory.Xrm.Tooling.csproj'), {
            crmSolutionName: this.props.crmSolutionName,
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

      this.fs.copy(
        this.templatePath('Nullfactory.Xrm.Tooling/Mappings/solution-mapping.xml'),
        this.destinationPath('Nullfactory.Xrm.Tooling/Mappings/' + this.props.crmSolutionName + '-mapping.xml')
      );

      this.fs.copy(
        this.templatePath('Nullfactory.Xrm.Tooling/Scripts/Sync-CrmSolution.ps1'),
        this.destinationPath('Nullfactory.Xrm.Tooling/Scripts/Sync-CrmSolution.ps1')
      );

      this.fs.copyTpl(
        this.templatePath('Nullfactory.Xrm.Tooling/Scripts/Sync-CrmSolution.Param.ps1'),
        this.destinationPath('Nullfactory.Xrm.Tooling/Scripts/Sync-CrmSolution.Param.ps1'), {
            visualStudioSolutionProjectPrefix: this.props.visualStudioSolutionProjectPrefix,
            crmSolutionName: this.props.crmSolutionName,
            crmUsername: this.props.crmUsername,
            crmPassword: this.props.crmPassword,
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
            crmUsername: this.props.crmUsername,
            crmPassword: this.props.crmPassword,
            crmServerUrl: this.props.crmServerUrl
        }
      );
  },

  _writePluginProject : function() {
    var pluginProjectName = this.props.visualStudioSolutionProjectPrefix + '.Xrm.Plugins'; 
    this.fs.copyTpl(
        this.templatePath('Project.Xrm.Plugins/Project.Xrm.Plugins.csproj'),
        this.destinationPath(pluginProjectName + '/'+ pluginProjectName + '.csproj'), {
          pluginProjectName: pluginProjectName
        }
    );

    this.fs.copyTpl(
        this.templatePath('Project.Xrm.Plugins/Properties/AssemblyInfo.cs'),
        this.destinationPath(pluginProjectName + '/Properties/AssemblyInfo.cs'), {
          pluginProjectName : pluginProjectName
        }
    );

    this.fs.copy(
        this.templatePath('Project.Xrm.Plugins/SimplePlugin.cs'),
        this.destinationPath(pluginProjectName + '/SimplePlugin.cs')
    );

    this.fs.copy(
        this.templatePath('Project.Xrm.Plugins/packages.config'),
        this.destinationPath(pluginProjectName + '/packages.config')
      );
  },

  _writeResourcesProject : function() {
    var generatedProjectName = this.props.visualStudioSolutionProjectPrefix + '.' + this.props.crmSolutionName + '.WebResources';
    this.fs.copyTpl(
      this.templatePath('Project.Solution.WebResources/Project.Solution.WebResources.csproj'),
      this.destinationPath(generatedProjectName + '/'+ generatedProjectName + '.csproj'), {
          visualStudioSolutionProjectPrefix: this.props.visualStudioSolutionProjectPrefix,
          crmSolutionName: this.props.crmSolutionName
      }
    );
  },

  install: function () {
    // this.installDependencies();
  }
});
