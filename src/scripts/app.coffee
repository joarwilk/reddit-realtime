timer = require '../lib/timer'
renderer = require '../lib/renderer'
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

    console.log @pageType

    button = document.createElement('button')
    button.id = 'toggle-realtime'
    button.innerHTML = 'TOGGLE'
    button.onclick = () ->
      timer.start()

    timer.addInterval '/.json', 5000, () ->
      console.log 'getting'
      xhr = new XMLHttpRequest()
      xhr.open 'GET', '//rl.reddit.com/r/all.json', true
      xhr.setRequestHeader 'Content-Type', 'application/json'

      xhr.onload = ->
        if xhr.status == 200
          root = JSON.parse(xhr.responseText)
          renderer.listing(root.data.children.map (node) -> node.data)
        return
      xhr.send()

    document.querySelector('#header-bottom-right').appendChild(button)

module.exports = App