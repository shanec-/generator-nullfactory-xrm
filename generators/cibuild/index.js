'use strict';
const Generator = require('yeoman-generator');
const prompt = require('./../app/prompt');
const utility = require('./../app/utility');

module.exports = class extends Generator {
  constructor(args, opts) {
    super(args, opts);

    this.argument('crmSolutionName', { required: false });
    this.argument('visualStudioSolutionProjectPrefix', { required: false });
    this.option('nosplash', { required: false, default: false });

    this.buildServer = this.options.buildServer;
    this.visualStudioSolutionProjectPrefix = this.options.visualStudioSolutionProjectPrefix;
    this.noSplash = this.options.nosplash;
  }

  prompting() {
    // Have Yeoman greet the user.
    utility.showSplash(this);

    return this.prompt([
      prompt.visualStudioSolutionProjectPrefix(this),
      prompt.buildServer(this)
    ]).then(props => {
      this.visualStudioSolutionProjectPrefix = utility.resolveParameter(
        this.visualStudioSolutionProjectPrefix,
        props.visualStudioSolutionProjectPrefix
      );

      this.buildServer = utility.resolveParameter(this.buildServer, props.buildServer);
    });
  }

  writing() {
    switch (this.buildServer) {
      case 'Visual Studio Team Services':
      default: {
        this._writeVsts();
      }
    }
  }

  // Vs solution
  _writeVsts() {
    this.fs.copyTpl(this.templatePath('vsts.y_l'), this.destinationPath('.vsts-ci.yml'), {
      visualStudioSolutionProjectPrefix: this.visualStudioSolutionProjectPrefix
    });
  }

  install() {
    /// this.installDependencies();
  }

  end() {
    utility.showInstructionsCiBuild(this);
  }
};
