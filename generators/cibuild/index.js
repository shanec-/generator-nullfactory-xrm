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
          choices: [
              "Visual Studio Team Services",
          ]
    }];

    return this.prompt(prompts).then(function (props) {
      // To access props later use this.props.someAnswer;
      this.props = props;
    }.bind(this));
  },

  writing: function () {
    switch(this.props.buildServer)
    {
      case("Visual Studio Team Services"):
      {
        this._writeVsts();
      }
    }    
  },

  // vs solution
  _writeVsts: function () {
    this.fs.copyTpl(
      this.templatePath('vsts.y_l'),
      this.destinationPath('.vsts-ci.yml'), {
        visualStudioSolutionProjectPrefix: this.props.visualStudioSolutionProjectPrefix,
      }
    );
  },

  install: function () {
    // this.installDependencies();
  },

  end: function () {
    var postInstallSteps =
      chalk.green.bold('\nSuccessfully generated YAML CI build.');

    this.log(postInstallSteps);
  }
});
///