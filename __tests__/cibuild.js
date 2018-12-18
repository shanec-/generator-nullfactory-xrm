'use strict';
var path = require('path');
var assert = require('yeoman-assert');
var helpers = require('yeoman-test');

describe('generator-nullfactory-xrm:cibuild', () => {
  beforeAll(() => {
    return helpers.run(path.join(__dirname, '../generators/cibuild')).withPrompts({
      visualStudioSolutionProjectPrefix: 'Test',
      buildServer: 'Azure DevOps - Pipelines'
    });
  });

  it('creates files', () => {
    assert.file(['.vsts-ci.yml']);
  });
});
