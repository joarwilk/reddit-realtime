class Score
  constructor: (start, end, duration) ->
    @interval  = end - start
    @end = end
    @start = start
    @duration = duration

  getAt: (time) ->
    if time >= @duration
      return @end
    else if time < 0
      throw new Error('time must be >= 0')

    return @start + (@interval * time/@duration)

module.exports = Score