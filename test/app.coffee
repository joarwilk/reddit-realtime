expect = require('chai').expect

App = require '../lib/app'

describe 'app', ->
  it 'should run without errors', ->
    expect(() ->
      (new App()).init()
    ).to.not.throw
