var App, reddit, timer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

timer = require('../lib/timer');

reddit = require('redcarb');

App = (function() {
  function App() {
    this.init = __bind(this.init, this);
  }

  App.prototype.init = function() {
    return timer.addInterval(function() {
      return reddit.comments('GoneWild', '2ig7dl', function(err, data, res) {
        return console.error(err, data);
      });
    });
  };

  return App;

})();

module.exports = App;
