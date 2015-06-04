var App, reddit, timer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

timer = require('../lib/timer');

reddit = require('redcarb');


/* **************

Main App class that binds everything together.
Handles url parsing, timer setups and creation of
button DOM object.
 */

App = (function() {
  function App() {
    this.start = __bind(this.start, this);
    this.init = __bind(this.init, this);
  }

  App.prototype.init = function() {
    var url;
    url = window.location.href;
    if (url.indexOf('/comments/')) {
      return this.pageType = 'post';
    } else if (url.indexOf('/r/')) {
      return this.pageType = 'subreddit';
    } else {
      return this.pageType = 'frontpage';
    }
  };

  App.prototype.start = function() {
    return timer.addInterval(function() {
      return reddit.comments('Javascript', '389wvc', function(err, data, res) {
        return console.error(err, data);
      });
    });
  };

  return App;

})();

module.exports = App;
