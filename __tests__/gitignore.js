'use strict';
var path = require('path');
var assert = require('yeoman-assert');
var helpers = require('yeoman-test');

describe('generator-nullfactory-xrm:gitignore', () => {
  beforeAll(() => {
    return helpers.run(path.join(__dirname, '../generators/gitignore'));
  });

  it('creates files', function() {
    assert.file(['.gitignore']);
  });
});
