###
# Data Fetcher Class

Handles managing the polling stack and executing
requsts against the reddit API.

It has to know about every call being made in
order to prevent API rate limit issues,
hence the singleton.

###

class Timer

  constructor: () ->
    @MAX_REQUESTS_PER_MINUTE = 25
    @MIN_REQUEST_WAIT_TIME = 60000 / @MAX_REQUESTS_PER_MINUTE
    @intervals = []

  addInterval: (url) =>
    # Extra arguments can be either pollrate and callback
    # or just callback
    throw new Error() unless arguments[1]?

    if typeof arguments[1] is 'function'
      pollingRate = @MIN_REQUEST_WAIT_TIME
      callback: arguments[1]
    else
      pollingRate = arguments[1]
      callback = arguments[2]

    interval = {
      url: url
      desiredPollRate: pollingRate
      pollingRate: 0
      offset: 0
      callback: callback
    }

    @intervals.push(interval)
    @adjustPollRates()

  clearAllIntervals: () =>
    @intervals.forEach (interval) ->
      clearInterval(interval.id)

    @intervals = []

  start: () =>
    for interval in @intervals
      offsetCallback = () ->
        interval.id = setInterval(interval.callback, interval.pollingRate)
      setTimeout(offsetCallback, interval.offset)

  stop: () =>
    for interval in @intervals
      clearInterval(interval.id)
      interval.id = 0

  adjustPollRates: () =>
    # get total amount of timer calls per minute
    total = @intervals.reduce (sum, interval) ->
      # calulate how many times this interval runs per minute
      sum + (60000 / interval.desiredPollRate)

    # If we're doing too many requests, each interval's poll rate
    # will be lower than the desired poll rate
    ratio = Math.min(1, total / @MAX_REQUESTS_PER_MINUTE)
    @intervals = @intervals.map (interval) ->
      interval.pollingRate = interval.desiredPollRate * ratio

module.exports = new Timer()
