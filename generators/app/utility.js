'use strict';
const chalk = require('chalk');
const yosay = require('yosay');

const VERSION = '1.7.0';

function showSplash(obj) {
  if (!obj.noSplash) {
    obj.log(
      yosay(
        chalk.keyword('orange')('nullfactory-xrm ' + VERSION) +
          '\n The' +
          chalk.green(' Dynamics 365') +
          ' Project Structure Generator!'
      )
    );
  }
}

function showInstructionsFull(obj) {
  var postInstallSteps =
    chalk.green.bold(
      '\nSuccessfully generated project structure for ' + obj.crmSolutionName + '.'
    ) +
    '\n\nFinalize the installation by: \n   1. Execute the ' +
    chalk.yellow('"_RunFirst.ps1"') +
    ' powershell script located in the root folder.\n';

  postInstallSteps +=
    '   2. Download and extracting the remote CRM solution by executing the ' +
    chalk.yellow.bold('Pull-CrmSolution.Param.ps1') +
    ' powershell script' +
    '\n      located in the Nullfactory.Xrm.Tooling\\Scripts folder.';

  if (obj.isAddPluginProject || obj.isAddWorkflowProject) {
    postInstallSteps +=
      '\n   3. Add a strong name key file to the plugin and/or workflow projects.';
  }

  obj.log(postInstallSteps);
  showCredits(obj);
}

function showInstructionsSolution(obj) {
  if (!obj.noSplash) {
    obj.log(
      chalk.green.bold(
        '\nSuccessfully generated project structure for ' + obj.crmSolutionName + '.'
      )
    );
    showCredits(obj);
  }
}

function showInstructionsTooling(obj) {
  if (!obj.noSplash) {
    if (obj.isToolingUpgrade) {
      obj.log(chalk.green.bold('\nSuccessfully upgraded scripts.'));
    } else {
      obj.log(chalk.yellow.bold('\nUser cancelled. No files changed.'));
    }
    showCredits(obj);
  }
}

function showInstructionsRepo(obj) {
  obj.log(chalk.green.bold('\nSuccessfully generated .gitignore file.'));
  showCredits(obj);
}

function showInstructionsCiBuild(obj) {
  obj.log(chalk.green.bold('\nSuccessfully generated YAML CI build.'));
  showCredits(obj);
}

function showCredits(obj) {
  obj.log(
    '\nPlease submit any issues found to ' +
      chalk.yellow.bold('https://github.com/shanec-/generator-nullfactory-xrm/issues')
  );
  obj.log('GPL-3.0 © Shane Carvalho \n\n');
}

function resolveParameter(optionParam, userInput) {
  if (optionParam === undefined) {
    return userInput;
  }
  return optionParam;
}

module.exports = {
  showSplash: showSplash,
  showInstructionsFull: showInstructionsFull,
  showInstructionsSolution: showInstructionsSolution,
  resolveParameter: resolveParameter,
  showInstructionsRepo: showInstructionsRepo,
  showInstructionsCiBuild: showInstructionsCiBuild,
  showInstructionsTooling: showInstructionsTooling
};
