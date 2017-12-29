'use strict';
var path = require('path');
var assert = require('yeoman-assert');
var helpers = require('yeoman-test');

describe('generator-nullfactory-xrm:cibuild', function () {
  before(function () {
    return helpers.run(path.join(__dirname, '../generators/cibuild'))
    .withPrompts({
        visualStudioSolutionProjectPrefix: 'Test',
        buildServer: 'Visual Studio Team Services'
      })
      .toPromise();
  });

  it('creates files', function () {
    assert.file([
      '.vsts-ci.yml'
    ]);
  });
});
///