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
      name: 'visualStudioSolutionProjectPrefix',
      message: 'Visual Studio solution project filename prefix?',
      default: 'Nullfactory'
    },
    {
      type: 'input',
      name: 'crmSolutionName',
      message: 'Source CRM solution name?',
      default: 'solution1'
    }];

    return this.prompt(prompts).then(function (props) {
      // To access props later use this.props.someAnswer;
      this.props = props;
    }.bind(this));
  },

  writing: function () {
    // initialize the crm solution project
    this._writeCrmSolutionProject();
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

  install: function () {
    // this.installDependencies();
  },

  end: function () {
    var postInstallSteps =
      chalk.green.bold('\nSuccessfully generated project structure for ' + this.props.crmSolutionName + '.');
    postInstallSteps += '\n\nPlease submit any issues found to ' + chalk.yellow.bold('https://github.com/shanec-/generator-nullfactory-xrm/issues');
    postInstallSteps += '\nGPL-3.0 © Shane Carvalho \n\n';

    this.log(postInstallSteps);
  }
});
///