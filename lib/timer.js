
/*
 * Data Fetcher Class

Handles managing the polling stack and executing
requsts against the reddit API.

It has to know about every call being made in
order to prevent API rate limit issues,
hence the singleton.
 */
var Timer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Timer = (function() {
  function Timer() {
    this.adjustPollRates = __bind(this.adjustPollRates, this);
    this.stop = __bind(this.stop, this);
    this.start = __bind(this.start, this);
    this.clearAllIntervals = __bind(this.clearAllIntervals, this);
    this.addInterval = __bind(this.addInterval, this);
    this.MAX_REQUESTS_PER_MINUTE = 25;
    this.MIN_REQUEST_WAIT_TIME = 60000 / this.MAX_REQUESTS_PER_MINUTE;
    this.intervals = [];
  }

  Timer.prototype.addInterval = function(url) {
    var callback, interval, pollingRate;
    if (arguments[1] == null) {
      throw new Error();
    }
    if (typeof arguments[1] === 'function') {
      pollingRate = this.MIN_REQUEST_WAIT_TIME;
      ({
        callback: arguments[1]
      });
    } else {
      pollingRate = arguments[1];
      callback = arguments[2];
    }
    interval = {
      url: url,
      desiredPollRate: pollingRate,
      pollingRate: 0,
      offset: 0,
      callback: callback
    };
    this.intervals.push(interval);
    return this.adjustPollRates();
  };

  Timer.prototype.clearAllIntervals = function() {
    this.intervals.forEach(function(interval) {
      return clearInterval(interval.id);
    });
    return this.intervals = [];
  };

  Timer.prototype.start = function() {
    var interval, offsetCallback, _i, _len, _ref, _results;
    _ref = this.intervals;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      interval = _ref[_i];
      offsetCallback = function() {
        return interval.id = setInterval(interval.callback, interval.pollingRate);
      };
      _results.push(setTimeout(offsetCallback, interval.offset));
    }
    return _results;
  };

  Timer.prototype.stop = function() {
    var interval, _i, _len, _ref, _results;
    _ref = this.intervals;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      interval = _ref[_i];
      clearInterval(interval.id);
      _results.push(interval.id = 0);
    }
    return _results;
  };

  Timer.prototype.adjustPollRates = function() {
    var ratio, total;
    total = this.intervals.reduce(function(sum, interval) {
      return sum + (60000 / interval.desiredPollRate);
    });
    ratio = Math.min(1, total / this.MAX_REQUESTS_PER_MINUTE);
    return this.intervals = this.intervals.map(function(interval) {
      return interval.pollingRate = interval.desiredPollRate * ratio;
    });
  };

  return Timer;

})();

module.exports = new Timer();
