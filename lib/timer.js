
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
    this.stop = __bind(this.stop, this);
    this.start = __bind(this.start, this);
    this.clearAllIntervals = __bind(this.clearAllIntervals, this);
    this.addInterval = __bind(this.addInterval, this);
    this.MIN_REQUEST_WAIT_TIME = 2500;
    this.intervals = [];
  }

  Timer.prototype.addInterval = function(url) {
    var callback, interval, pollingRate;
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
      pollingRate: Math.max(this.MIN_REQUEST_WAIT_TIME, pollingRate),
      callback: callback
    };
    return this.intervals.push(interval);
  };

  Timer.prototype.clearAllIntervals = function() {
    this.intervals.forEach(function(interval) {
      return clearInterval(interval.id);
    });
    return this.intervals = [];
  };

  Timer.prototype.start = function() {
    var interval, _i, _len, _ref, _results;
    _ref = this.intervals;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      interval = _ref[_i];
      _results.push(interval.id = setInterval(interval.callback, interval.pollingRate));
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

  return Timer;

})();

module.exports = new Timer();
