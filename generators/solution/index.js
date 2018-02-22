'use strict';
const Generator = require('yeoman-generator');
const chalk = require('chalk');
const yosay = require('yosay');

module.exports = class extends Generator{
  prompting() {
    // Have Yeoman greet the user.
    this.log(yosay(
        chalk.keyword('orange')('nullfactory-xrm') + '\n The' + chalk.green(' Dynamics 365') + ' Project Structure Generator!'
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
  }

  writing() {
    // initialize the crm solution project
    this._writeCrmSolutionProject();
  }

  // crm solution
  _writeCrmSolutionProject() {
    var generatedSolutionName = this.props.visualStudioSolutionProjectPrefix + '.' + this.props.crmSolutionName;
    this.fs.copyTpl(
      this.templatePath('Project.Solution/Project.Solution.csproj'),
      this.destinationPath(generatedSolutionName + '/' + generatedSolutionName + '.csproj'), {
        crmSolutionName: this.props.crmSolutionName,
        visualStudioSolutionProjectPrefix: this.props.visualStudioSolutionProjectPrefix,
        visualStudioSolutionName: this.props.visualStudioSolutionName
      }
    );
  }

  install() {
    // this.installDependencies();
  }

  end() {
    var postInstallSteps =
      chalk.green.bold('\nSuccessfully generated project structure for ' + this.props.crmSolutionName + '.');
    postInstallSteps += '\n\nPlease submit any issues found to ' + chalk.yellow.bold('https://github.com/shanec-/generator-nullfactory-xrm/issues');
    postInstallSteps += '\nGPL-3.0 © Shane Carvalho \n\n';

    this.log(postInstallSteps);
  }
};
///
