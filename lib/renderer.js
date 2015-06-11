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
  listing: function(posts) {
    var listing;
    listing = Array.prototype.slice.call(document.querySelectorAll('.thing.link'));
    return posts.forEach(function(post, i) {
      var asd, elem, elements, id, interval, startScore, transition;
      elem = document.querySelector('[data-fullname="' + post.name + '"]');
      if (elem) {
        elements = {
          dislikes: elem.querySelector('.score.dislikes'),
          unvoted: elem.querySelector('.score.unvoted'),
          likes: elem.querySelector('.score.likes')
        };
        startScore = parseInt(elements.unvoted.innerHTML);
        if (isNaN(startScore)) {
          startScore = post.score;
        }
        transition = new ScoreTransition(startScore, post.score, 5000);
        id = 0;
        asd = 0;
        interval = Math.random() * 500;
        window.requestAnimationFrame();
        id = setInterval(function() {
          var score, time;
          time = asd++ * interval;
          if (time > 5000) {
            clearInterval(id);
            return;
          }
          score = Math.floor(transition.getAt(time));
          elements.dislikes.innerHTML = score - 1;
          elements.unvoted.innerHTML = score;
          return elements.likes.innerHTML = score + 1;
        }, interval);
        return elem.querySelector('.comments').innerHTML = post.num_comments + " comments";
      } else {
        return console.info('new thing - ', post.title);
      }
    });
  }
};
