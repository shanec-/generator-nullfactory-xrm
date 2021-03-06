'use strict';
const Generator = require('yeoman-generator');
const uuidv4 = require('uuid/v4');
const prompt = require('./../app/prompt');
const utility = require('./../app/utility');

module.exports = class extends Generator {
  constructor(args, opts) {
    super(args, opts);

    this.argument('crmSolutionName', { required: false });
    this.argument('visualStudioSolutionProjectPrefix', { required: false });
    this.option('nosplash', { required: false, default: false });

    this.crmSolutionName = this.options.crmSolutionName;
    this.visualStudioSolutionProjectPrefix = this.options.visualStudioSolutionProjectPrefix;
    this.noSplash = this.options.nosplash;
  }

  prompting() {
    utility.showSplash(this);

    var prompts = [
      prompt.visualStudioSolutionProjectPrefix(this),
      prompt.crmSolutionName(this)
    ];

    return this.prompt(prompts).then(props => {
      this.visualStudioSolutionProjectPrefix = utility.resolveParameter(
        this.visualStudioSolutionProjectPrefix,
        props.visualStudioSolutionProjectPrefix
      );

      this.crmSolutionName = utility.resolveParameter(
        this.crmSolutionName,
        props.crmSolutionName
      );
    });
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
        visualStudioSolutionProjectPrefix: this.visualStudioSolutionProjectPrefix
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
    utility.showInstructionsSolution(this);
  }
};
