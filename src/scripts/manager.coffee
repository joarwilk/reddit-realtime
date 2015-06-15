renderer = require '../lib/renderer'

class ListManager
  constructor: (updateInterval) ->
    @updateInterval = updateInterval

  update: (rawPosts) =>
    # If the seen flag is not set to true, remove post after update
    @posts.forEach (post) -> post.seen = false

    rawPosts.forEach (rawPost, i) =>
      if @posts[rawPost.id] is undefined
        @addFromJSON(rawPost)
        @setIndex(@posts[rawPost.id], i)

      post = @posts[rawPost.id]
      post.seen = true

      scoreTransition = new ScoreTransition(post.score, rawPost.score, @updateInterval)
      commentCountTransition = new ScoreTransition(parseInt(startCommentCount), post.num_comments, @updateInterval)

    @posts.forEach (post) => @deletePost(post) unless post.seen

  deletePost: (post) ->
    renderer.removeListElement(post.elements.root)
    @posts[post.id] = undefined

  setIndex: (post, index) ->
    @posts = @posts.map (post) ->
      if post.index >= index
        post.index--
      return post
    post.index = index
    renderer.insertListElement(post, index)

  parseExisting: () ->
    elements = document.querySelectorAll('#siteTable > .thing.link')
    for element in elements
      @addFromElement(element)

  addFromJSON: (postJSON) ->
    elem = renderer.createListElementFromPost(postJSON)
    @addFromElement(elem)

  addFromElement: (postElement) ->
    elements = {
      root: postElement
      dislikes: postElement.querySelector('.score.dislikes')
      unvoted: postElement.querySelector('.score.unvoted')
      likes: postElement.querySelector('.score.likes')
      comments: postElement.querySelector('.comments')
      index: postElement.querySelector('.index')
    }

    index: parseInt(elements.index.innerHTML)

    score = parseInt(elements.unvoted.innerHTML)
    score = 0 if isNaN score

    if elements.comments.classList.contains('emtpty')
      commentCount = 0
    else
      commentCount = elements.comments.innerHTML.match(/\d/g).join('')

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
    @startTime = timestamp unless @startTime
    time = timestamp - @startTime

    @posts.forEach (post) =>
      if (Math.random() < 0.1)
        return

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

