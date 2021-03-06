assert = require 'assert'
expect = require('chai').expect
sinon  = require 'sinon'

timer = require '../lib/timer'

describe 'Timer', ->
  beforeEach 'clear intervals', ->
    timer.clearAllIntervals()

  describe 'clearInterval', ->
    it 'clears all the intervals', ->
      timer.addInterval () ->
      timer.clearAllIntervals()

      expect(timer.intervals).to.be.empty

  describe 'addInterval', ->
    it 'adds another item to the interval array', ->
      timer.addInterval () ->

      expect(timer.intervals).to.have.length 1

    it 'can accept first argument as function', ->
      timer.addInterval () ->

      expect(timer.intervals[0].callback).to.not.be.undefined

    it 'can accept first argument as poll rate', ->
      timer.addInterval 5000, () ->

      expect(timer.intervals[0].pollingRate).to.equal 5000

    it 'requires at least one argument', ->
      expect(() ->
        timer.addInterval()
      ).to.throw

    it 'polls as fast as possible if time is omitted', ->
      timer.addInterval () ->

      expect(timer.intervals[0].pollingRate).to.equal timer.MIN_REQUEST_WAIT_TIME

    # FIXME: Should we use delays?
    it.skip 'alternates requests if two intervals have equal poll rates', ->
      timer.addInterval () ->
      timer.addInterval () ->

      expect(timer.intervals[1].offset).to.equal timer.MIN_REQUEST_WAIT_TIME

      it 'halves the individual poll rate if two intervals are going as fast as possible', ->
      timer.addInterval () ->
      timer.addInterval () ->

      expect(timer.intervals[1].pollRate).to.equal timer.MIN_REQUEST_WAIT_TIME * 2

  describe 'start', ->
    before => @clock = sinon.useFakeTimers()
    after => @clock.restore()

    it 'gives each interval an id', =>
      timer.addInterval () ->
      timer.start()

      @clock.tick(1)

      for interval in timer.intervals
        expect(interval.id).not.be.null

    it 'calls the interval callback after 2500ms', =>
      spy = sinon.spy()

      timer.addInterval 2500, spy

      @clock.tick(2500)

      expect(spy).to.be.calledOnce


  describe 'stop', ->
    it 'clears all interval ids', ->
      timer.addInterval () ->
      timer.start()
      setTimeout(() ->
        for interval in timer.intervals
          expect(interval.id).to.equal 0
      , 0)



