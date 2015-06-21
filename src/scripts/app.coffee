ListManager = require '../lib/listManager'
timer = require '../lib/timer'
renderer = require '../lib/renderer'
reddit = require '../lib/reddit'
settings = require '../lib/settings'

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

    if @pageType is 'frontpage'
      manager = new ListManager(settings.LIST_UPDATE_INTERVAL)
      manager.parseExisting()

      id = timer.addInterval settings.LIST_UPDATE_INTERVAL, () ->
        reddit.frontpage (list) ->
          manager.update(list.children.map (node) -> node.data)

      renderer.insertRealtimeToggleButton().onclick = () ->
        if timer.running then timer.stop(id) else timer.start(id)


module.exports = App