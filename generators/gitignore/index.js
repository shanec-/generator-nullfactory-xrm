'use strict';
var yeoman = require('yeoman-generator');
var chalk = require('chalk');
var yosay = require('yosay');

module.exports = yeoman.Base.extend({
  prompting: function () {
    // Have Yeoman greet the user.
   this.log(yosay(
      'Welcome to ' + chalk.red('nullfactory-xrm') + '\n The Dynamics CRM project structure generator!'
    ));
  },

  writing: function () {
    this.fs.copy(
      this.templatePath('-gitignore'),
      this.destinationPath('.gitignore')
    );
  },

  install: function () {
    //this.installDependencies();
  },

  end: function () {
    var postInstallSteps = chalk.green.bold('\nSuccessfully generated .gitignore file.');

    this.log(postInstallSteps);
  }
});
