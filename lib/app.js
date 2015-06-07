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
    var button, url;
    url = window.location.href;
    if (url.indexOf('/comments/') !== -1) {
      this.pageType = 'post';
    } else if (url.indexOf('/wiki/') !== -1) {
      this.pageType = 'wiki';
    } else if (url.indexOf('/r/') !== -1) {
      this.pageType = 'subreddit';
    } else {
      this.pageType = 'frontpage';
    }
    button = $('<button id="toggle-realtime">TOGGLE</button>');
    button.click((function(_this) {
      return function() {
        return _this.start();
      };
    })(this));
    return button.appendTo($('#header-bottom-right'));
  };

  App.prototype.start = function() {
    switch (this.pageType) {
      case 'frontpage':
        return timer.addInterval(function() {
          return reddit.hot(function(err, data, res) {
            return console.error(err, data);
          });
        });
    }
  };

  return App;

})();

module.exports = App;
