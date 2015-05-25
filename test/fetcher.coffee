assert = require 'assert'
expect = require('chai').expect

fetcher = require '../lib/fetcher'

describe 'Fetcher', ->
  beforeEach 'clear intervals', ->
    fetcher.clearAllIntervals()

  describe 'clearInterval', ->
    it 'clears all the intervals', ->
      fetcher.addInterval '/.json', () ->
      fetcher.clearAllIntervals()

      expect(fetcher.intervals).to.be.empty

  describe 'addInterval', ->
    it 'adds another item to the interval array', ->
      fetcher.addInterval '/.json', () ->

      expect(fetcher.intervals).to.have.length 1

    it 'can accept second argument as function', ->
      fetcher.addInterval '/.json', () ->

      expect(fetcher.callback).to.not.be.undefined

    it 'can accept second argument as poll rate', ->
      fetcher.addInterval '/.json', 5000, () ->

      expect(fetcher.pollingRate).to.equal 5000

    it 'polls as fast as possible if time is omitted', ->
      fetcher.addInterval '/.json', () ->

      expect(fetcher.intervals[0].pollingRate).to.equal fetcher.MIN_REQUEST_WAIT_TIME

    it 'alternates requests if two intervals have equal poll rates', ->
      fetcher.addInterval '/.json', () ->
      fetcher.addInterval '/.html', () ->

  describe 'start', ->
    it 'gives each interval an id', ->
      for interval in fetcher.intervals
        expect(interval.id).to.be.above 0



