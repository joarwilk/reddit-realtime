var Score;

Score = (function() {
  function Score(start, end, duration) {
    this.interval = end - start;
    this.end = end;
    this.start = start;
    this.duration = duration;
  }

  Score.prototype.getAt = function(time) {
    if (time >= this.duration) {
      return this.end;
    } else if (time < 0) {
      throw new Error('time must be >= 0');
    }
    return this.start + (this.interval * time / this.duration);
  };

  return Score;

})();

module.exports = Score;
