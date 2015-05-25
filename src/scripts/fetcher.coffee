###
# Data Fetcher Class

Handles managing the polling stack and executing
requsts against the reddit API.

It has to know about every call being made in
order to prevent API rate limit issues,
hence the singleton.

###

class Fetcher

  constructor: () ->
    @MIN_REQUEST_WAIT_TIME = 2500
    @intervals = []

  addInterval: (url) =>
    # Extra arguments can be either pollrate and callback
    # or just callback
    if typeof arguments[1] is 'function'
      pollingRate = @MIN_REQUEST_WAIT_TIME
      callback: arguments[1]
    else
      pollingRate = arguments[1]
      callback = arguments[2]

    interval = {
      url: url
      pollingRate: Math.max(@MIN_REQUEST_WAIT_TIME, pollingRate)
      callback: callback
    }

    interval.id = setInterval(interval.callback, interval.pollingRate)

    @intervals.push(interval)

  clearAllIntervals: () =>
    @intervals.forEach (interval) ->
      clearInterval(interval.id)

    @intervals = []

module.exports = new Fetcher()
