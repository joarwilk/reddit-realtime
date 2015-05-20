assert = require 'assert'
chai = require('chai')
should = chai.should
chai.config.includeStack = true;

Randomizer = require '../scripts/randomizer'

describe 'DataParser', ->
  describe 'parseMessages', ->
    #ddas
  describe 'parsePost', ->
    it 'should return a ThingState with the correct score', ->
      assert.equal 2, Randomizer.spread 2