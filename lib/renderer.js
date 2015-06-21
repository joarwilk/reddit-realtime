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
  getListing: function() {
    return Array.prototype.slice.call(document.querySelectorAll('#siteTable > .thing.link'));
  },
  insertRealtimeToggleButton: function() {
    var button;
    button = document.createElement('button');
    button.id = 'toggle-realtime';
    button.innerHTML = 'TOGGLE';
    document.querySelector('#header-bottom-right').appendChild(button);
    return button;
  },
  swapListElements: function(first, second) {
    first.classList.add('swapping');
    return second.parentNode.insertBefore(first, second.nextSibling);
  },
  insertListElement: function(post, index) {
    var ref;
    post.elements.root.classList.add('inserting');
    ref = this.getListing()[index];
    return ref.parentNode.insertBefore(post.elements.root, ref.nextSibling);
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
    }, 0);
  },
  highlightDownvote: function(postListItem) {
    postListItem.elements.unvoted.classList.add('flash-downvote');
    return setTimeout(function() {
      return postListItem.elements.unvoted.classList.remove('flash-downvote');
    }, 0);
  },
  highlightCommentCountChange: function(postListItem) {
    postListItem.elements.comments.classList.add('flash-countchange');
    return setTimeout(function() {
      return postListItem.elements.comments.classList.remove('flash-countchange');
    }, 0);
  },
  createListElementFromPost: function(post) {
    var elem;
    elem = document.createElement('div');
    elem.innerHTML = "<div class=\"thing inserted id-" + post.id + " odd link\" data-fullname=\"post.id\" onclick= \"click_thing(this)\">\n  <p class=\"parent\">\n  </p>\n  <span class=\"rank\">0</span>\n\n  <div class=\"midcol unvoted\">\n    <div class=\"arrow up login-required\" onclick=\n    \"$(this).vote(r.config.vote_hash, null, event)\" tabindex=\"0\">\n    </div>\n\n\n    <div class=\"score dislikes\">\n      " + (post.score - 1) + "\n    </div>\n\n\n    <div class=\"score unvoted\">\n      " + post.score + "\n    </div>\n\n\n    <div class=\"score likes\">\n      " + (post.score + 1) + "\n    </div>\n\n\n    <div class=\"arrow down login-required\" onclick=\n    \"$(this).vote(r.config.vote_hash, null, event)\" tabindex=\"0\">\n    </div>\n  </div>\n  <a class=\"thumbnail may-blank loggedin\" href=\n  \"" + post.url + "\"><img alt=\"\" height=\"70\" src=\n  \"" + post.thumbnail + "\"\n  width=\"70\"></a>\n\n  <div class=\"entry unvoted lcTagged\">\n    <p class=\"title\"><a class=\"title may-blank loggedin srTagged imgScanned\"\n    href=\"" + post.url + "\" id=\"img3\" name=\"img3\" tabindex=\"1\"\n    type=\"IMAGE\">" + post.title + "</a> <span class=\"domain\">(<a href=\n    \"/domain/" + post.domain + "\">" + post.domain + "</a>)</span></p>\n    <a class=\n    \"toggleImage expando-button collapsed collapsedExpando image linkImg\">&nbsp;</a>\n\n    <p class=\"tagline\">submitted <time class=\"live-timestamp\" datetime=\n    \"2015-06-11T11:09:17+00:00\" title=\"Thu Jun 11 11:09:17 2015 UTC\">2 hours\n    ago</time> by <a class=\"author may-blank id-t2_o1att userTagged\" href=\n    \"http://www.reddit.com/user/ChairwomanPaoZeDong\">ChairwomanPaoZeDong</a><span class=\"RESUserTag\"><a class=\"userTagLink RESUserTagImage\"\n    href=\"javascript:void(0)\" title=\"set a tag\"></a></span> <a class=\n    \"voteWeight\" href=\"javascript:void(0)\" style=\n    \"display: none;\">[vw]</a><span class=\"userattrs\"></span> to <a class=\n    \"subreddit hover may-blank\" href=\n    \"http://www.reddit.com/r/Stuff/\">/r/Stuff</a></p>\n\n\n    <ul class=\"flat-list buttons\">\n      <li class=\"first\">\n        <a class=\"comments may-blank\" href=\n        \"http://www.reddit.com/r/Stuff/comments/39fhvl/bad_luck_ellen/\">" + post.num_comments + "\n        comments</a>\n      </li>\n\n\n      <li class=\"share\">\n        <a class=\"post-sharing-button\" href=\"javascript:%20void%200;\">share</a>\n      </li>\n\n\n      <li class=\"link-save-button save-button\">\n        <a href=\"#\">save</a>\n      </li>\n\n\n      <li>\n        <form action=\"/post/hide\" class=\"state-button hide-button\" method=\n        \"post\">\n          <input name=\"executed\" type=\"hidden\" value=\"hidden\"><span><a href=\n          \"javascript:void(0);\">hide</a></span>\n        </form>\n      </li>\n\n\n      <li class=\"report-button\">\n        <a class=\"action-thing\" data-action-form=\"#report-action-form\" href=\n        \"javascript:void(0)\">report</a>\n      </li>\n\n\n      <li><span class=\"redditSingleClick\">[l+c]</span>\n      </li>\n    </ul>\n\n\n    <div class=\"expando\" style=\"display: none\">\n      <span class=\"error\">loading...</span>\n    </div>\n  </div>\n\n\n  <div class=\"child\">\n  </div>\n\n\n  <div class=\"clearleft\">\n  </div>\n</div>";
    return elem;
  }
};
