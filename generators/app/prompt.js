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

// {
//   type: 'input',
//   name: 'visualStudioSolutionName',
//   message: 'Visual Studio solution filename?',
//   default: 'Nullfactory'
// },
// {
//   type: 'input',
//   name: 'visualStudioSolutionProjectPrefix',
//   message: 'Visual Studio solution project filename prefix?',
//   default: 'Nullfactory'
// },
// {
//   type: 'input',
//   name: 'crmServerUrl',
//   message: 'Source CRM server url?',
//   default: 'https://sandbox.crm6.dynamics.com/'
// },
// {
//   type: 'input',
//   name: 'crmSolutionName',
//   message: 'Source CRM solution name?',
//   default: 'solution1'
// },
// {
//   type: 'confirm',
//   name: 'isAddWebResourceProject',
//   message: 'Add *.WebResource project?',
//   default: true
// },
// {
//   type: 'confirm',
//   name: 'isAddPluginProject',
//   message: 'Add *.Plugin project?',
//   default: true
// },
// {
//   type: 'confirm',
//   name: 'isAddWorkflowProject',
//   message: 'Add *.Workflow project?',
//   default: true
// }

module.exports = {
  visualStudioSolutionName: visualStudioSolutionName,
  visualStudioSolutionProjectPrefix: visualStudioSolutionProjectPrefix,
  crmServerUrl: crmServerUrl,
  crmSolutionName: crmSolutionName,
  isAddWebResourceProject: isAddWebResourceProject,
  isAddPluginProject: isAddPluginProject,
  isAddWorkflowProject: isAddWorkflowProject
};
