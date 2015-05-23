assert = require 'assert'
expect = require('chai').expect

describe 'Fetcher', ->
  describe 'setInterval', ->
    it 'should not do anything', ->
      expect({}).to.exist
