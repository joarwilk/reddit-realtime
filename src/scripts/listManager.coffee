renderer = require '../lib/renderer'
timer = require '../lib/timer'
ScoreTransition = require '../lib/transitions/score'

class ListManager
  constructor: (updateInterval) ->
    @posts = []
    @updateInterval = updateInterval
    @timestampDirty = true

    window.requestAnimationFrame(@tick)

  update: (rawPosts) =>
    @timestampDirty = true

    @posts.forEach (post) -> post.seen = false

    rawPosts.forEach (rawPost, i) =>
      # If this list item is new, insert it
      if @posts[rawPost.name] is undefined
        @addFromJSON(rawPost)
        @setIndex(@posts[rawPost.name], i)
      # Flag this post to have been seen so we dont delete it
      post = @posts[rawPost.name]
      post.seen = true

      # Shift the score to the newer value
      post.prevScore = post.score
      post.score = rawPost.score

      # Shift the comment count to the newer value
      post.prevCommentCount = post.commentCount
      post.commentCount = rawPost.num_comments

    for own id, post of @posts
      unless post.seen
        @deletePost(post)
        return
      post.scoreTransition = new ScoreTransition(post.prevScore, post.score, @updateInterval)
      post.commentCountTransition = new ScoreTransition(post.prevCommentCount, post.commentCount, @updateInterval)


  deletePost: (post) ->
    renderer.removeListElement(post.elements.root)
    @posts[post.id] = undefined

  setIndex: (post, index) ->
    # Shift every post at the specified index
    # down a notch, and insert the post
    # at that index
    for own id, p of @posts
      if p.index >= index
        p.index--
    post.index = index
    renderer.insertListElement(post, index)

  parseExisting: () ->
    elements = document.querySelectorAll('#siteTable > .thing.link')
    for element in elements
      @addFromElement(element)


  addFromJSON: (postJSON) ->
    elem = renderer.createListElementFromPost(postJSON)
    @addFromElement(elem)
    return elem

  addFromElement: (postElement) ->
    elements = {
      root:     postElement
      id:       postElement.getAttribute('data-fullname')
      dislikes: postElement.querySelector('.score.dislikes')
      unvoted:  postElement.querySelector('.score.unvoted')
      likes:    postElement.querySelector('.score.likes')
      comments: postElement.querySelector('.comments')
      index:    postElement.querySelector('.rank')
    }

    index = parseInt(elements.index.innerHTML)

    score = parseInt(elements.unvoted.innerHTML)
    score = 0 if isNaN score

    if elements.comments.classList.contains('emtpty')
      commentCount = 0
    else
      commentCount = parseInt(elements.comments.innerHTML.replace(' comments', ''))

    id = postElement.getAttribute('data-fullname')

    @posts[id] = {
      elements: elements
      score: score
      commentCount: commentCount
      index: index
    }

  ###
  For use in window.requestAnimationFrame
  ###
  tick: (timestamp) =>
    #unless timer.running
     # window.requestAnimationFrame(@tick)
      #return

    @startTime = timestamp if @timestampDirty
    time = timestamp - @startTime

    @timestampDirty = false

    for own id, post of @posts
      continue unless post.scoreTransition

      score = Math.floor(post.scoreTransition.getAt(time))
      commentCount = Math.floor(post.commentCountTransition.getAt(time))

      if post.score != score or post.prevCommentCount != commentCount

        if post.score < score
          renderer.highlightUpvote(post)
        else if post.score > score
          renderer.highlightDownvote(post)

        if post.prevCommentCount < commentCount
          renderer.highlightCommentCountChange(post)

        post.score = score
        post.commentCount = commentCount

        renderer.updateListItem(post)

    window.requestAnimationFrame(@tick)

module.exports = ListManager