var ListManager, ScoreTransition, renderer, timer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty;

renderer = require('../lib/renderer');

timer = require('../lib/timer');

ScoreTransition = require('../lib/transitions/score');

ListManager = (function() {
  function ListManager(updateInterval) {
    this.tick = __bind(this.tick, this);
    this.update = __bind(this.update, this);
    this.posts = [];
    this.updateInterval = updateInterval;
    window.requestAnimationFrame(this.tick);
  }

  ListManager.prototype.update = function(rawPosts) {
    this.posts.forEach(function(post) {
      return post.seen = false;
    });
    rawPosts.forEach((function(_this) {
      return function(rawPost, i) {
        var post;
        if (_this.posts[rawPost.name] === void 0) {
          _this.addFromJSON(rawPost);
          _this.setIndex(_this.posts[rawPost.name], i);
        }
        post = _this.posts[rawPost.name];
        post.seen = true;
        post.prevScore = post.score;
        post.score = rawPost.score;
        post.prevCommentCount = post.commentCount;
        return post.commentCount = rawPost.num_comments;
      };
    })(this));
    return this.posts.forEach((function(_this) {
      return function(post) {
        if (!post.seen) {
          _this.deletePost(post);
          return;
        }
        post.scoreTransition = new ScoreTransition(post.prevScore, post.score, _this.updateInterval);
        return post.commentCountTransition = new ScoreTransition(post.prevCommentCount, post.commentCount, _this.updateInterval);
      };
    })(this));
  };

  ListManager.prototype.deletePost = function(post) {
    renderer.removeListElement(post.elements.root);
    return this.posts[post.id] = void 0;
  };

  ListManager.prototype.setIndex = function(post, index) {
    this.posts = this.posts.map(function(post) {
      if (post.index >= index) {
        post.index--;
      }
      return post;
    });
    post.index = index;
    return renderer.insertListElement(post, index);
  };

  ListManager.prototype.parseExisting = function() {
    var element, elements, _i, _len, _results;
    elements = document.querySelectorAll('#siteTable > .thing.link');
    _results = [];
    for (_i = 0, _len = elements.length; _i < _len; _i++) {
      element = elements[_i];
      _results.push(this.addFromElement(element));
    }
    return _results;
  };

  ListManager.prototype.addFromJSON = function(postJSON) {
    var elem;
    elem = renderer.createListElementFromPost(postJSON);
    this.addFromElement(elem);
    return elem;
  };

  ListManager.prototype.addFromElement = function(postElement) {
    var commentCount, elements, id, index, score;
    elements = {
      id: postElement.getAttribute('data-fullname'),
      root: postElement,
      dislikes: postElement.querySelector('.score.dislikes'),
      unvoted: postElement.querySelector('.score.unvoted'),
      likes: postElement.querySelector('.score.likes'),
      comments: postElement.querySelector('.comments'),
      index: postElement.querySelector('.rank')
    };
    index = parseInt(elements.index.innerHTML);
    score = parseInt(elements.unvoted.innerHTML);
    if (isNaN(score)) {
      score = 0;
    }
    if (elements.comments.classList.contains('emtpty')) {
      commentCount = 0;
    } else {
      commentCount = parseInt(elements.comments.innerHTML.replace(' comments', ''));
    }
    id = postElement.getAttribute('data-fullname');
    return this.posts[id] = {
      elements: elements,
      score: score,
      commentCount: commentCount,
      index: index
    };
  };


  /*
  For use in window.requestAnimationFrame
   */

  ListManager.prototype.tick = function(timestamp) {
    var commentCount, id, post, score, time, _ref;
    if (!this.startTime) {
      this.startTime = timestamp;
    }
    time = timestamp - this.startTime;
    _ref = this.posts;
    for (id in _ref) {
      if (!__hasProp.call(_ref, id)) continue;
      post = _ref[id];
      if (!post.scoreTransition) {
        continue;
      }
      score = Math.floor(post.scoreTransition.getAt(time));
      commentCount = Math.floor(post.commentCountTransition.getAt(time));
      if (post.score !== score || post.prevCommentCount !== commentCount) {
        console.info(post.score);
        if (post.score < score) {
          renderer.highlightUpvote(post);
        } else if (post.score > score) {
          renderer.highlightDownvote(post);
        }
        if (post.prevCommentCount < commentCount) {
          renderer.highlightCommentCountChange(post);
        }
        post.score = score;
        post.commentCount = commentCount;
        renderer.updateListItem(post);
      }
    }
    return window.requestAnimationFrame(this.tick);
  };

  return ListManager;

})();

module.exports = ListManager;
