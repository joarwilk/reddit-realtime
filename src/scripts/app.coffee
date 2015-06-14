timer = require '../lib/timer'
renderer = require '../lib/renderer'
reddit = require '../lib/reddit'

#reddit = require 'redcarb'

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

    timer.addInterval 5000, () ->
      reddit.frontpage (list) ->
        renderer.listing(list.children.map (node) -> node.data)

    button = document.createElement('button')
    button.id = 'toggle-realtime'
    button.innerHTML = 'TOGGLE'
    button.onclick = () ->
      timer.start()

    document.querySelector('#header-bottom-right').appendChild(button)

module.exports = App