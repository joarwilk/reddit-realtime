timer = require '../lib/timer'
reddit = require 'redcarb'

### **************

Main App class that binds everything together.
Handles url parsing, timer setups and creation of
button DOM object.

###
class App

  # Check which type of page we're on and prepare
  # everything accordingly
  # Can be frontpage, subreddit or post
  init: () =>
    url = window.location.href

    if url.indexOf('/comments/')
      @pageType = 'post'
    else if url.indexOf('/r/')
      @pageType = 'subreddit'
    else
      @pageType = 'frontpage'

  start: () =>
    timer.addInterval () ->
      reddit.comments 'Javascript', '389wvc', (err, data, res) ->
        console.error(err, data)


module.exports = App