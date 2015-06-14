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

  addInterval: (args...) =>
    # Arguments can be either pollrate and callback
    # or just callback
    throw new Error() unless args[0]?

    if typeof args[0] is 'function'
      pollingRate = @MIN_REQUEST_WAIT_TIME
      callback = args[0]
    else
      pollingRate = args[0]
      callback = args[1]

    interval = {
      id: null
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
        console.log 'setting callback'
        console.info interval
        interval.id = setInterval(interval.callback, interval.pollingRate)
      setTimeout(offsetCallback, interval.offset)
      interval.callback()

  stop: () =>
    for interval in @intervals
      clearInterval(interval.id)
      interval.id = 0

  adjustPollRates: () =>
    # get total amount of desired api calls per minute
    total = @intervals
      .map (interval) ->
        return (60000 / interval.desiredPollRate)
      .reduce (sum, rate) ->
        return sum + rate

    # If we're doing too many requests, adjust the timing
    # intervals so we're within limit
    ratio = Math.min(1, @MAX_REQUESTS_PER_MINUTE / total)
    @intervals = @intervals.map (interval) ->
      interval.pollingRate = interval.desiredPollRate * ratio
      return interval

module.exports = new Timer()
