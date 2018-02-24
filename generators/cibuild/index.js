'use strict';
const Generator = require('yeoman-generator');
const chalk = require('chalk');
const yosay = require('yosay');

module.exports = class extends Generator {
  prompting() {
    // Have Yeoman greet the user.
    this.log(
      yosay(
        chalk.keyword('orange')('nullfactory-xrm') +
          '\n The' +
          chalk.green(' Dynamics 365') +
          ' Project Structure Generator!'
      )
    );

    var prompts = [
      {
        type: 'input',
        name: 'visualStudioSolutionProjectPrefix',
        message: 'Visual Studio solution project filename prefix?',
        default: 'Nullfactory'
      },
      {
        type: 'list',
        name: 'buildServer',
        message: 'What type of build server are you using?',
        choices: ['Visual Studio Team Services']
      }
    ];

    return this.prompt(prompts).then(
      function(props) {
        // To access props later use this.props.someAnswer;
        this.props = props;
      }.bind(this)
    );
  }

  writing() {
    switch (this.props.buildServer) {
      case 'Visual Studio Team Services':
      default: {
        this._writeVsts();
      }
    }
  }

  // Vs solution
  _writeVsts() {
    this.fs.copyTpl(this.templatePath('vsts.y_l'), this.destinationPath('.vsts-ci.yml'), {
      visualStudioSolutionProjectPrefix: this.props.visualStudioSolutionProjectPrefix
    });
  }

  install() {
    /// this.installDependencies();
  }

  end() {
    var postInstallSteps = chalk.green.bold('\nSuccessfully generated YAML CI build.');

    this.log(postInstallSteps);
  }
};
