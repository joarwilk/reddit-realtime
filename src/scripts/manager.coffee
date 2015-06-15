renderer = require '../lib/renderer'
class ListManager
  constructor: (updateInterval) ->

  parseExisting: () ->
    elements = document.querySelectorAll('#siteTable > .thing.link')
    for element in elements
      @addFromElement(element)

  addFromElement: (postElement) ->
    elements = {
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

    @posts.push({
      elements: elements
      score: score
      commentCount: commentCount
      index: index
    })

  addFromJSON: (postJSON) ->
    elem = renderer.createListElementFromPost(postJSON)
    @addFromElement(elem)

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

