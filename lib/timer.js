
/*
 * Data Fetcher Class

Handles managing the polling stack and executing
requsts against the reddit API.

It has to know about every call being made in
order to prevent API rate limit issues,
hence the singleton.
 */
var Fetcher,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

Fetcher = (function() {
  function Fetcher() {
    this.clearAllIntervals = __bind(this.clearAllIntervals, this);
    this.addInterval = __bind(this.addInterval, this);
    this.MIN_REQUEST_WAIT_TIME = 2500;
    this.intervals = [];
  }

  Fetcher.prototype.addInterval = function(url) {
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
    interval.id = setInterval(interval.callback, interval.pollingRate);
    return this.intervals.push(interval);
  };

  Fetcher.prototype.clearAllIntervals = function() {
    this.intervals.forEach(function(interval) {
      return clearInterval(interval.id);
    });
    return this.intervals = [];
  };

  return Fetcher;

})();

module.exports = new Fetcher();
