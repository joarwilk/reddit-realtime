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

    if url.indexOf('/comments/') != -1
      @pageType = 'post'
    else if url.indexOf('/wiki/') != -1
      @pageType = 'wiki'
    else if url.indexOf('/r/') != -1
      @pageType = 'subreddit'
    else
      @pageType = 'frontpage'

    button = $('<button id="toggle-realtime">TOGGLE</button>')
    button.click () =>
      @start()
    button.appendTo($('#header-bottom-right'))

  start: () =>
    switch @pageType
      when 'frontpage'
        timer.addInterval () ->
          reddit.hot (err, data, res) ->
            console.error(err, data)

module.exports = App