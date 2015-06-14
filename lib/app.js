var App, reddit, renderer, timer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

timer = require('../lib/timer');

renderer = require('../lib/renderer');

reddit = require('../lib/reddit');


/* **************

Main App class that binds everything together.
Handles url parsing, timer setups and creation of
button DOM object.
 */

App = (function() {
  function App() {
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
    timer.addInterval(5000, function() {
      return reddit.frontpage(function(list) {
        return renderer.listing(list.children.map(function(node) {
          return node.data;
        }));
      });
    });
    button = document.createElement('button');
    button.id = 'toggle-realtime';
    button.innerHTML = 'TOGGLE';
    button.onclick = function() {
      return timer.start();
    };
    return document.querySelector('#header-bottom-right').appendChild(button);
  };

  return App;

})();

module.exports = App;
