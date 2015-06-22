ListManager = require '../lib/listManager'
timer = require '../lib/timer'
renderer = require '../lib/renderer'
reddit = require '../lib/reddit'
RedditUser = require '../lib/redditUser'
settings = require '../lib/settings'

#reddit = require 'redcarb'

### **************

Main App class that binds everything together.
Handles url parsing, timer setups and creation of
button DOM object.

###
class App
  constructor: (url) =>
    # Find which page we're on
    if url.indexOf('/comments/') != -1
      @pageType = 'post'
    else if url.indexOf('/wiki/') != -1
      @pageType = 'wiki'
    else if url.indexOf('/r/') != -1
      @pageType = 'subreddit'
    else
      @pageType = 'frontpage'

  init: () =>
    if @pageType is 'frontpage'
      manager = new ListManager(settings.LIST_UPDATE_INTERVAL)
      manager.parseExisting()

      id = timer.addInterval settings.LIST_UPDATE_INTERVAL, () ->
        reddit.frontpage (list) ->
          manager.update(list.children.map (node) -> node.data)

      button = renderer.insertRealtimeToggleButton()
      button.onclick = () ->
        if timer.running then timer.stop(id) else timer.start(id)

    if settings.REALTIME_USER_DATA_ENABLED
      user = null

      # Create user data interval
      id = timer.addInterval 10000, () ->
        reddit.user (userdata) ->
          user.update(userdata, 10000)

      # Fetch initial user info
      reddit.user (data) ->
        user = new RedditUser(data.messages, data.score, data.comment_score)
        timer.start(id)



module.exports = App