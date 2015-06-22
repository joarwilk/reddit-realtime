reddit = require '../lib/reddit'
sinon = require 'sinon'
expect = require('chai').expect

describe 'Reddit', ->
  before 'setup fake xmlhttprequests', ->
    sinon.useFakeXMLHttpRequest()

  describe 'request', ->
    it 'does an xhr request for the specified path', ->
      request('/new.json', () ->)

      expect(xhr).to.equal null

    it 'calls the callback on success', ->
      spy = sinon.spy()
      reddit.request('/', spy)

      expect(spy.calledOnce).to.exist

    it 'throws an error if the path is not relative', ->
      expect(() ->
        reddit.request('http://google.com', () -> )
      ).to.throw

  describe 'frontpage', ->
    it 'calls request with /.json as path', ->
      request = sinon.spy(reddit.request)

      reddit.frontpage('hot', () ->)
      expect(request).to.have.been.calledOnce

