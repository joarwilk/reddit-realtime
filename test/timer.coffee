assert = require 'assert'
expect = require('chai').expect

timer = require '../lib/timer'

describe 'Timer', ->
  beforeEach 'clear intervals', ->
    timer.clearAllIntervals()

  describe 'clearInterval', ->
    it 'clears all the intervals', ->
      timer.addInterval '/.json', () ->
      timer.clearAllIntervals()

      expect(timer.intervals).to.be.empty

  describe 'addInterval', ->
    it 'adds another item to the interval array', ->
      timer.addInterval '/.json', () ->

      expect(timer.intervals).to.have.length 1

    it 'can accept second argument as function', ->
      timer.addInterval '/.json', () ->

      expect(timer.intervals[0].callback).to.not.be.undefined

    it 'can accept second argument as poll rate', ->
      timer.addInterval '/.json', 5000, () ->

      expect(timer.intervals[0].pollingRate).to.equal 5000

    it 'polls as fast as possible if time is omitted', ->
      timer.addInterval '/.json', () ->

      expect(timer.intervals[0].pollingRate).to.equal timer.MIN_REQUEST_WAIT_TIME

    it 'alternates requests if two intervals have equal poll rates', ->
      timer.addInterval '/.json', () ->
      timer.addInterval '/.html', () ->

  describe 'start', ->
    it 'gives each interval an id', ->
      timer.start()

      for interval in timer.intervals
        expect(interval.id).to.be.above 0

  describe 'stop', ->
    it 'clears all interval ids', ->
      for interval in timer.intervals
        expect(interval.id).to.equal 0


