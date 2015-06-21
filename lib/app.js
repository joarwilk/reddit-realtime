var App, ListManager, reddit, renderer, settings, timer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

ListManager = require('../lib/listManager');

timer = require('../lib/timer');

renderer = require('../lib/renderer');

reddit = require('../lib/reddit');

settings = require('../lib/settings');


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
    var id, manager, url;
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
    if (this.pageType === 'frontpage') {
      manager = new ListManager(settings.LIST_UPDATE_INTERVAL);
      manager.parseExisting();
      id = timer.addInterval(settings.LIST_UPDATE_INTERVAL, function() {
        return reddit.frontpage(function(list) {
          return manager.update(list.children.map(function(node) {
            return node.data;
          }));
        });
      });
      return renderer.insertRealtimeToggleButton().onclick = function() {
        if (timer.running) {
          return timer.stop(id);
        } else {
          return timer.start(id);
        }
      };
    }
  };

  return App;

})();

module.exports = App;
