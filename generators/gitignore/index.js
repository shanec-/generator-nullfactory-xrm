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
  }

  writing() {
    this.fs.copy(
      this.templatePath('-gitignore'),
      this.destinationPath('.gitignore')
    );
  }

  install() {
    //this.installDependencies();
  }

  end() {
    var postInstallSteps = chalk.green.bold('\nSuccessfully generated .gitignore file.');

    this.log(postInstallSteps);
  }
};
