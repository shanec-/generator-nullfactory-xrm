function visualStudioSolutionName(obj) {
  return {
    type: `input`,
    name: `visualStudioSolutionName`,
    default: `Nullfactory`,
    message: `Visual Studio solution filename?`,
    when: () => {
      // If the parameter is passed in as an option then, skip.
      return obj.options.visualStudioSolutionName === undefined;
    }
  };
}

function visualStudioSolutionProjectPrefix(obj) {
  return {
    store: true,
    type: `input`,
    name: `visualStudioSolutionProjectPrefix`,
    default: `Nullfactory`,
    message: `Visual Studio solution project filename prefix?`,
    when: () => {
      // If the parameter is passed in as an option then, skip.
      return obj.options.visualStudioSolutionProjectPrefix === undefined;
    }
  };
}

function crmServerUrl(obj) {
  return {
    type: `input`,
    name: `crmServerUrl`,
    default: `https://sandbox.crm6.dynamics.com/`,
    message: `Source CRM server url?`,
    when: () => {
      // If the parameter is passed in as an option then, skip.
      return obj.options.crmServerUrl === undefined;
    }
  };
}

function crmSolutionName(obj) {
  return {
    type: `input`,
    name: `crmSolutionName`,
    default: `solution1`,
    message: `Source CRM solution name?`,
    when: () => {
      // If the parameter is passed in as an option then, skip.
      return obj.options.crmSolutionName === undefined;
    }
  };
}

function isAddWebResourceProject(obj) {
  return {
    type: `confirm`,
    name: `isAddWebResourceProject`,
    default: true,
    message: `Add *.WebResource project?`,
    when: () => {
      // If the parameter is passed in as an option then, skip.
      return obj.options.isAddWebResourceProject === undefined;
    }
  };
}

function isAddPluginProject(obj) {
  return {
    type: `confirm`,
    name: `isAddPluginProject`,
    default: true,
    message: `Add *.Plugin project?`,
    when: () => {
      // If the parameter is passed in as an option then, skip.
      return obj.options.isAddPluginProject === undefined;
    }
  };
}

function isAddWorkflowProject(obj) {
  return {
    type: `confirm`,
    name: `isAddWorkflowProject`,
    default: true,
    message: `Add *.Workflow project?`,
    when: () => {
      // If the parameter is passed in as an option then, skip.
      return obj.options.isAddWorkflowProject === undefined;
    }
  };
}

function isToolingUpgrade(obj) {
  return {
    type: `confirm`,
    name: `isToolingUpgrade`,
    default: true,
    message: `Proceed with upgrading the tooling scripts?`,
    when: () => {
      // If the parameter is passed in as an option then, skip.
      return obj.options.isAddWorkflowProject === undefined;
    }
  };
}

function buildServer(obj) {
  return {
    type: `list`,
    name: `buildServer`,
    default: `Azure DevOps - Pipelines`,
    message: `What type of build server are you using?`,
    choices: ['Azure DevOps - Pipelines'],
    when: () => {
      // If the parameter is passed in as an option then, skip.
      return obj.options.buildServer === undefined;
    }
  };
}

module.exports = {
  visualStudioSolutionName: visualStudioSolutionName,
  visualStudioSolutionProjectPrefix: visualStudioSolutionProjectPrefix,
  crmServerUrl: crmServerUrl,
  crmSolutionName: crmSolutionName,
  isAddWebResourceProject: isAddWebResourceProject,
  isAddPluginProject: isAddPluginProject,
  isAddWorkflowProject: isAddWorkflowProject,
  isToolingUpgrade: isToolingUpgrade,
  buildServer: buildServer
};
