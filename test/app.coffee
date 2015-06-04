expect = require('chai').expect

App = require '../lib/app'

describe 'app', ->
  before ->
    window = {
      location: {
        href: ''
      }
    }

  it 'should run without errors', ->
    expect(() ->
      (new App()).init()
    ).to.not.throw

  it 'detects if current page is the frontpage', ->
    window.location.href = 'http://reddit.com/'

    app = new App()
    app.init()

    expect(app.pageType).to.equal 'frontpage'

  it 'detects if current page is a subreddit', ->
    window.location.href = 'http://reddit.com/r/pics'

    app = new App()
    app.init()

    expect(app.pageType).to.equal 'subreddit'

  it 'detects if current page is a post', ->
    window.location.href = 'http://www.reddit.com/r/javascript/comments/389wvc/7_essential_javascript_functions_debounce_poll/'

    app = new App()
    app.init()

    expect(app.pageType).to.equal 'post'


