'use strict';
const Generator = require('yeoman-generator');
const utility = require('./../app/utility');

module.exports = class extends Generator {
  prompting() {
    utility.showSplash(this);
  }

  writing() {
    this.fs.copy(this.templatePath('-gitignore'), this.destinationPath('.gitignore'));
  }

  install() {}

  end() {
    utility.showInstructionsRepo(this);
  }
};
