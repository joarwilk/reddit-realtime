var ScoreTransition;

ScoreTransition = require('../lib/transitions/score');

module.exports = {
  commentTree: function(element, comments, doc) {
    var root;
    if (doc == null) {
      doc = document.createDocumentFragment();
    }
    return root = doc.createElement('div');
  },
  createListElementFromPost: function(post) {
    var classname, e, elem, _i, _len, _ref;
    elem = document.createElement('div');
    elem.innerHTML = post.score;
    elem.setAttribute('data-fullname', post.name);
    _ref = [' score dislikes', ' score unvoted', ' score likes', ' comments'];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      classname = _ref[_i];
      e = document.createElement('div');
      e.setAttribute('class', classname);
      e.innerHTML = '123';
      elem.appendChild(e);
    }
    return elem;
  },
  swapListElements: function(first, second) {
    first.classList.add('swapping');
    return post.insertBefore(first, second);
  },
  insertListElement: function(post, index) {
    post.classList.add('inserting');
    return post.insertBefore(this.getListing()[index], post);
  },
  removeListElement: function(post) {
    post.classList.add('removing');
    return setTimeout((function() {
      return post.remove();
    }), 500);
  },
  highlightUpvote: function(postListItem) {
    postListItem.elements.unvoted.classList.add('flash-upvote');
    return setTimeout(function() {
      return postListItem.elements.unvoted.classList.remove('flash-upvote');
    }, 6000);
  },
  highlightDownvote: function(postListItem) {
    postListItem.elements.unvoted.classList.add('flash-downvote');
    return setTimeout(function() {
      return postListItem.elements.unvoted.classList.remove('flash-downvote');
    }, 6000);
  },
  highlightCommentCountChange: function(postListItem) {
    postListItem.elements.comments.classList.add('flash-countchange');
    return setTimeout(function() {
      return postListItem.elements.comments.classList.remove('flash-countchange');
    }, 0);
  },
  listing: function(posts) {
    var listing, render, start;
    listing = Array.prototype.slice.call(document.querySelectorAll('.thing.link'));
    posts = posts.map((function(_this) {
      return function(post, i) {
        var commentCountTransition, elem, elements, scoreTransition, startCommentCount, startScore;
        elem = document.querySelector('[data-fullname="' + post.name + '"]');
        if (elem) {
          elements = {
            dislikes: elem.querySelector('.score.dislikes'),
            unvoted: elem.querySelector('.score.unvoted'),
            likes: elem.querySelector('.score.likes'),
            comments: elem.querySelector('.comments')
          };
        } else {
          console.info('new thing - ', post.title);
          _this.insertListElement(_this.createListElementFromPost(post), i);
          elements = {
            dislikes: elem.children[0],
            unvoted: elem.children[1],
            likes: elem.children[2],
            comments: elem.children[3]
          };
        }
        startScore = parseInt(elements.unvoted.innerHTML);
        if (isNaN(startScore)) {
          startScore = post.score;
        }
        scoreTransition = new ScoreTransition(startScore, post.score, 5000);
        startCommentCount = elements.comments.innerHTML.match(/\d/g).join('');
        commentCountTransition = new ScoreTransition(parseInt(startCommentCount), post.num_comments, 5000);
        return {
          elements: elements,
          scoreTransition: scoreTransition,
          commentCountTransition: commentCountTransition
        };
      };
    })(this));
    start = null;
    render = (function(_this) {
      return function(timestamp) {
        var time;
        if (!start) {
          start = timestamp;
        }
        time = timestamp - start;
        if (time > 5000) {
          return;
        }
        posts.forEach(function(post) {
          var commentCount, score;
          if (Math.random() < 0.1) {
            return;
          }
          score = Math.floor(post.scoreTransition.getAt(time));
          commentCount = Math.floor(post.commentCountTransition.getAt(time));
          post.elements.dislikes.innerHTML = score - 1;
          post.elements.unvoted.innerHTML = score;
          post.elements.likes.innerHTML = score + 1;
          post.elements.comments.innerHTML = commentCount + " comments";
          if (post.prevScore < score) {
            _this.highlightUpvote(post);
          } else if (post.prevScore > score) {
            _this.highlightDownvote(post);
          }
          if (post.prevCommentCount < commentCount) {
            _this.highlightCommentCountChange(post);
          }
          post.prevScore = score;
          return post.prevCommentCount = commentCount;
        });
        return window.requestAnimationFrame(render);
      };
    })(this);
    return window.requestAnimationFrame(render);
  }
};
