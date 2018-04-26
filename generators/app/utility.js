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

function showPostInstructions(obj) {
  var postInstallSteps = chalk.green.bold(
    '\nSuccessfully generated project structure for ' + this.crmSolutionName + '.'
  );
  postInstallSteps +=
    '\n\nPlease submit any issues found to ' +
    chalk.yellow.bold('https://github.com/shanec-/generator-nullfactory-xrm/issues');
  postInstallSteps += '\nGPL-3.0 © Shane Carvalho \n\n';

  obj.log(postInstallSteps);
}

function showPostInstructionsSolution(obj) {
  if (!obj.noSplash) {
    var postInstallSteps = chalk.green.bold(
      '\nSuccessfully generated project structure for ' + this.crmSolutionName + '.'
    );
    postInstallSteps +=
      '\n\nPlease submit any issues found to ' +
      chalk.yellow.bold('https://github.com/shanec-/generator-nullfactory-xrm/issues');
    postInstallSteps += '\nGPL-3.0 © Shane Carvalho \n\n';

    obj.log(postInstallSteps);
  }
}

module.exports = {
  showSplash: showSplash,
  showPostInstructions: showPostInstructions,
  showPostInstructionsSolution: showPostInstructionsSolution
};
