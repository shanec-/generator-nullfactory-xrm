'use strict';
const Generator = require('yeoman-generator');
const chalk = require('chalk');
const yosay = require('yosay');
const uuidv4 = require('uuid/v4');
const prompt = require('./../app/prompt');

module.exports = class extends Generator {
  constructor(args, opts) {
    super(args, opts);

    this.argument('crmSolutionName');
    this.argument('visualStudioSolutionProjectPrefix');
    this.argument('visualStudioSolutionName');
    this.option('nosplash');

    this.log(this.options.crmSolutionName);
    this.log(this.options.visualStudioSolutionProjectPrefix);
    this.log(this.options.visualStudioSolutionName);
    this.log(this.options.nosplash);

    this.crmSolutionName = this.options.crmSolutionName;
    this.visualStudioSolutionProjectPrefix = this.options.crmSolutionName;
    this.visualStudioSolutionName = this.options.crmSolutionName;
    this.nosplash = this.options.nosplash;
  }

  prompting() {
    // Have Yeoman greet the user.
    if (!this.nosplash) {
      this.log(
        yosay(
          chalk.keyword('orange')('nullfactory-xrm') +
            '\n The' +
            chalk.green(' Dynamics 365') +
            ' Project Structure Generator!'
        )
      );
    }

    var prompts = [
      prompt.visualStudioSolutionProjectPrefix(this),
      prompt.crmSolutionName(this)
    ];

    return this.prompt(prompts).then(
      function(props) {
        // To access props later use this.someAnswer;
        // this = props;
        this.visualStudioSolutionProjectPrefix = props.visualStudioSolutionProjectPrefix;
        this.crmSolutionName = props.crmSolutionName;
      }.bind(this)
    );
  }

  writing() {
    // Initialize the crm solution project
    this._writeCrmSolutionProject();

    // Generate the mapping file
    this._writeMappingFile();
  }

  // Crm solution
  _writeCrmSolutionProject() {
    var generatedSolutionName =
      this.visualStudioSolutionProjectPrefix + '.' + this.crmSolutionName;
    this.fs.copyTpl(
      this.templatePath('Project.Solution/Project.Solution.csproj'),
      this.destinationPath(
        generatedSolutionName + '/' + generatedSolutionName + '.csproj'
      ),
      {
        uniqueProjectId: uuidv4(),
        crmSolutionName: this.crmSolutionName,
        visualStudioSolutionProjectPrefix: this.visualStudioSolutionProjectPrefix,
        visualStudioSolutionName: this.visualStudioSolutionName
      }
    );
  }

  // Solution mapping file
  _writeMappingFile() {
    this.fs.copy(
      this.templatePath('Nullfactory.Xrm.Tooling/Mappings/solution-mapping.xml'),
      this.destinationPath(
        'Nullfactory.Xrm.Tooling/Mappings/' + this.crmSolutionName + '-mapping.xml'
      )
    );
  }

  install() {
    /// this.installDependencies();
  }

  end() {
    var postInstallSteps = chalk.green.bold(
      '\nSuccessfully generated project structure for ' + this.crmSolutionName + '.'
    );
    postInstallSteps +=
      '\n\nPlease submit any issues found to ' +
      chalk.yellow.bold('https://github.com/shanec-/generator-nullfactory-xrm/issues');
    postInstallSteps += '\nGPL-3.0 © Shane Carvalho \n\n';

    this.log(postInstallSteps);
  }
};
