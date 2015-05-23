assert = require 'assert'
chai = require('chai')
expect = chai.expect

randomizer = require '../lib/randomizer'

transitions = {
  score: require '../lib/transitions/score'
  post: require '../lib/transitions/post'
}

describe 'Transitions', ->
  describe 'score', ->
    sampleObject = {}

    beforeEach ->
      sampleObject = {
        start: 42
        end: 42
        duration: 10
      }

    it 'always returns the end value if start == end', ->
      transition = new transitions.Score(sampleObject)

      for n in [0..10]
        score = transition.getAt(n)
        expect(score).to.equal(10)

    it 'should create a set of keyframes', ->
      sampleObject.keyframeCount = 4

      transition = new transitions.Score(sampleObject)

      expect(transition).to.have.property("keyframes").with.length 4
