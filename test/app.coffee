expect = require('chai').expect
sinon = require 'sinon'
jsdom = require 'jsdom'

App = require '../lib/app'

describe 'app', ->

  it 'should run without errors', ->
    expect(() ->
      (new App('')).init()
    ).to.not.throw

  it 'detects if current page is the frontpage', ->
    app = new App('http://reddit.com/')
    app.init()

    expect(app.pageType).to.equal 'frontpage'

  it 'detects if current page is a subreddit', ->
    app = new App('http://reddit.com/r/pics')
    app.init()

    expect(app.pageType).to.equal 'subreddit'

  it 'detects if current page is a post', ->
    app = new App('http://www.reddit.com/r/javascript/comments/389wvc/7_essential_javascript_functions_debounce_poll/')
    app.init()

    expect(app.pageType).to.equal 'post'


