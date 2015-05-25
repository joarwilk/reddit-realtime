assert = require 'assert'
expect = require('chai').expect

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
        start: 100
        end: 100
        duration: 10
      }

    it 'should create a set of keyframes', ->
      transition = new transitions.Score(sampleObject)

      expect(transition).to.have.property("keyframes").with.length.above(0)

    it 'should create a specific number of keyframes if specified', ->
      sampleObject.keyframeCount = 4

      transition = new transitions.Score(sampleObject)

      expect(transition).to.have.property("keyframes").with.length 4

    it 'always returns the end value if start == end', ->
      transition = new transitions.Score(sampleObject)

      for n in [0..10]
        score = transition.getAt(n)
        expect(score).to.equal(10)

    it 'should be a linear progression between each keyframe', ->
      transition = Object.create transitions.Score({
        start: 100
        end: 500
        duration: 2000
      })

      expect(undefined).to.not.exist
