assert = require 'assert'
expect = require('chai').expect

transitions = {
  Score: require '../lib/transitions/score'
  Post: require '../lib/transitions/post'
}

describe 'Transitions', ->
  describe 'score', ->

    it 'should throw if not called with all arguments', ->
      expect(() ->
        new transitions.Score()
      ).to.throw

    it.skip 'should create a set of keyframes', ->
      transition = new transitions.Score(sampleObject)

      expect(transition).to.have.property("keyframes").with.length.above(0)

    it.skip 'should create a specific number of keyframes if specified', ->
      sampleObject.keyframeCount = 4

      transition = new transitions.Score(sampleObject)

      expect(transition).to.have.property("keyframes").with.length 4

    it 'always returns the end value if start == end', ->
      transition = new transitions.Score(100, 100, 10)

      for n in [0..10]
        score = transition.getAt(n)
        expect(score).to.equal(100)

    describe 'getAt', ->

      it 'returns the end value if param > duration', ->

        transition = new transitions.Score(100, 500, 2000)

        score = transition.getAt(3000)

        expect(score).to.equal 500

      it 'throws if param is < 0', ->
        transition = new transitions.Score(0, 100, 100)

        expect(() ->
          transition.getAt(-1)
        ).to.throw

      describe 'when transitioning linearly', ->
        duration = 2000
        for i in [0..duration] by 200
          progress = i/duration * 100

          it 'returns ' + progress + ' at ' + progress + '%', ->

            transition = new transitions.Score(0, 100, duration)

            score = transition.getAt(i)

            expect(score).to.equal progress

        it 'accounts for the start value', ->
          transition = new transitions.Score(50, 100, 1000)

          expect(transition.getAt(500)).to.equal 75



