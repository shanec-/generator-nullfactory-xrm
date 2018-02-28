'use strict';
var path = require('path');
var assert = require('yeoman-assert');
var helpers = require('yeoman-test');

describe('generator-nullfactory-xrm:solution', () => {
  beforeAll(function() {
    return helpers.run(path.join(__dirname, '../generators/solution')).withPrompts({
      visualStudioSolutionProjectPrefix: 'SuperSolution',
      crmSolutionName: 'FirstSolution'
    });
  });

  it('creates files', function() {
    assert.file(['SuperSolution.FirstSolution/SuperSolution.FirstSolution.csproj']);
  });
});
