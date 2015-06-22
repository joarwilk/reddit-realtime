audio = require 'audio'

###

Handles logic and state for
the active user

###
class RedditUser
  constructor: (messageCount, karma...) ->
    @prevMessageCount = messageCount
    @messageCount = messageCount
    @karma = {
      submissions: karma[0]
      comments: karma[1]
    }

  update: (user, interval) ->
    # Only update if there's been a change
    if user.messageCount != @messageCount
      @prevMessageCount = @messageCount

      # Only play a sound if there is a new message,
      # not if there is less new ones than before
      if @messageCount > @prevMessageCount
        audio.play('message_alert')

      renderer.highlighMessageCountChange(@messageCount)

    if @karma.submissions != user.score
      @karma.submissions = user.score

      renderer.highlighKarmaCountChange(@karma.submissions, true)

    if @karma.comments != user.comment_score
      @karma.comments = user.comment_score

      renderer.highlighKarmaCountChange(@karma.comments, false)

module.exports = RedditUser
