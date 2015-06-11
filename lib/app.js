var App, renderer, timer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

timer = require('../lib/timer');

renderer = require('../lib/renderer');


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
    console.log(this.pageType);
    button = document.createElement('button');
    button.id = 'toggle-realtime';
    button.innerHTML = 'TOGGLE';
    button.onclick = function() {
      return timer.start();
    };
    timer.addInterval('/.json', 5000, function() {
      var xhr;
      console.log('getting');
      xhr = new XMLHttpRequest();
      xhr.open('GET', '//rl.reddit.com/r/all.json', true);
      xhr.setRequestHeader('Content-Type', 'application/json');
      xhr.onload = function() {
        var root;
        if (xhr.status === 200) {
          root = JSON.parse(xhr.responseText);
          renderer.listing(root.data.children.map(function(node) {
            return node.data;
          }));
        }
      };
      return xhr.send();
    });
    return document.querySelector('#header-bottom-right').appendChild(button);
  };

  return App;

})();

module.exports = App;
