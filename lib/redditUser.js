var RedditUser, audio,
  __slice = [].slice;

audio = require('../lib/audio');


/*

Handles logic and state for
the active user
 */

RedditUser = (function() {
  function RedditUser() {
    var karma, messageCount;
    messageCount = arguments[0], karma = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    this.prevMessageCount = messageCount;
    this.messageCount = messageCount;
    this.karma = {
      submissions: karma[0],
      comments: karma[1]
    };
  }

  RedditUser.prototype.update = function(user, interval) {
    if (user.messageCount !== this.messageCount) {
      this.prevMessageCount = this.messageCount;
      if (this.messageCount > this.prevMessageCount) {
        audio.play('message_alert');
      }
      renderer.highlighMessageCountChange(this.messageCount);
    }
    if (this.karma.submissions !== user.score) {
      this.karma.submissions = user.score;
      renderer.highlighKarmaCountChange(this.karma.submissions, true);
    }
    if (this.karma.comments !== user.comment_score) {
      this.karma.comments = user.comment_score;
      return renderer.highlighKarmaCountChange(this.karma.comments, false);
    }
  };

  return RedditUser;

})();

module.exports = RedditUser;
