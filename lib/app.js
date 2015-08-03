var App, ListManager, RedditUser, reddit, renderer, settings, timer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

ListManager = require('../lib/listManager');

timer = require('../lib/timer');

renderer = require('../lib/renderer');

reddit = require('../lib/reddit');

RedditUser = require('../lib/redditUser');

settings = require('../lib/settings');


/* **************

Main App class that binds everything together.
Handles url parsing, timer setups and creation of
button DOM object.
 */

App = (function() {
  function App(url) {
    this.init = __bind(this.init, this);
    if (url.indexOf('/comments/') !== -1) {
      this.pageType = 'post';
    } else if (url.indexOf('/wiki/') !== -1) {
      this.pageType = 'wiki';
    } else if (url.indexOf('/r/') !== -1) {
      this.pageType = 'subreddit';
      this.subreddit = url.split('/')[2];
      console.info('settings', url, this.subreddit);
    } else {
      this.pageType = 'frontpage';
    }
    console.info(url);
  }

  App.prototype.init = function() {
    var button, id, manager, refresh, user;
    if (this.pageType === 'post') {

    } else {
      manager = new ListManager(settings.LIST_UPDATE_INTERVAL);
      manager.parseExisting();
      if (this.pageType === 'frontpage') {
        refresh = function() {
          return reddit.frontpage('hot', function(list) {
            console.info('list', list);
            return manager.update(list.children);
          });
        };
      } else {
        refresh = (function(_this) {
          return function() {
            return reddit.subreddit('hot', _this.subreddit, function(list) {
              return manager.update(list.children);
            });
          };
        })(this);
      }
      id = timer.addInterval(settings.LIST_UPDATE_INTERVAL, refresh);
      timer.start(id);
    }
    console.info(id, 'ID');
    button = renderer.insertRealtimeToggleButton();
    button.onclick = function() {
      if (timer.running) {
        return timer.stop(id);
      } else {
        return timer.start(id);
      }
    };
    if (settings.REALTIME_USER_DATA_ENABLED) {
      user = null;
      id = timer.addInterval(10000, function() {
        return reddit.user(function(userdata) {
          return user.update(userdata, 10000);
        });
      });
      return reddit.user(function(data) {
        user = new RedditUser(data.messages, data.score, data.comment_score);
        return timer.start(id);
      });
    }
  };

  return App;

})();

module.exports = App;
