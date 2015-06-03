timer = require '../lib/timer'
reddit = require 'redcarb'

class App
  init: () =>
    timer.addInterval () ->
      reddit.comments 'GoneWild', '2ig7dl', (err, data, res) ->
        console.error(err, data)


module.exports = App