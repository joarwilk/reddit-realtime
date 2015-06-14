ScoreTransition = require '../lib/transitions/score'

module.exports = {
  commentTree: (element, comments, doc) ->
    doc = document.createDocumentFragment() unless doc?

    root = doc.createElement('div')
    #for comment in comments
      # do nothing

  getListing: () ->
    return Array::slice.call(document.querySelectorAll('.thing.link'))

  createListElementFromPost: (post) ->
    elem = document.createElement('div')
    elem.innerHTML = post.score
    elem.setAttribute('data-fullname', post.name)

    for classname in [' score dislikes', ' score unvoted', ' score likes', ' comments']
      e = document.createElement('div')
      e.setAttribute('class', classname)
      e.innerHTML = '123'
      elem.appendChild(e)
    console.info elem
    return elem

  swapListElements: (first, second) ->
    first.classList.add('swapping')
    second.parentNode.insertBefore(first, second.nextSibling)

  insertListElement: (post, index) ->
    post.classList.add('inserting')
    ref = @getListing()[index]
    ref.parentNode.insertBefore(post, ref.nextSibling)

  removeListElement: (post) ->
    post.classList.add('removing')
    setTimeout(( -> post.remove()), 500)

  highlightUpvote: (postListItem) ->
    # Make the score text orange and then instantly fade it back to normal
    postListItem.elements.unvoted.classList.add('flash-upvote')
    setTimeout () ->
      postListItem.elements.unvoted.classList.remove('flash-upvote')
    , 0

  highlightDownvote: (postListItem) ->
    # Make the score text blue and then instantly fade it back to normal
    postListItem.elements.unvoted.classList.add('flash-downvote')
    setTimeout () ->
      postListItem.elements.unvoted.classList.remove('flash-downvote')
    , 0

  highlightCommentCountChange: (postListItem) ->
    postListItem.elements.comments.classList.add('flash-countchange')
    setTimeout () ->
      postListItem.elements.comments.classList.remove('flash-countchange')
    , 0


  listing: (posts) ->
    # Convert nodelist to array
    listing = @getListing()

    posts = posts.map (post, i) =>
      elem = document.querySelector('[data-fullname="' + post.name + '"]')

      if elem
        elements = {
          dislikes: elem.querySelector('.score.dislikes')
          unvoted: elem.querySelector('.score.unvoted')
          likes: elem.querySelector('.score.likes')
          comments: elem.querySelector('.comments')
        }

        if listing.indexOf(elem) - 10 != i
          console.info 'swapping', i
          @swapListElements(listing[i + 10], elem)
          listing = @getListing()
      else
        console.info 'new thing - ', post.title

        elem = @createListElementFromPost(post)
        @insertListElement(elem, i)

        elements = {
          dislikes: elem.children[0]
          unvoted: elem.children[1]
          likes: elem.children[2]
          comments: elem.children[3]
        }

        listing = @getListing()

      startScore = parseInt(elements.unvoted.innerHTML)
      startScore = post.score if isNaN startScore
      scoreTransition = new ScoreTransition(startScore, post.score, 5000)

      # Remove " comments" from string
      if elements.comments.classList.contains('emtpty')
        startCommentCount = 0
      else
        startCommentCount = elements.comments.innerHTML.match(/\d/g).join('')

      commentCountTransition = new ScoreTransition(parseInt(startCommentCount), post.num_comments, 5000)

      return {
        elements: elements
        scoreTransition: scoreTransition
        commentCountTransition: commentCountTransition
      }

    start = null
    render = (timestamp) =>
      start = timestamp unless start
      time = timestamp - start

      if time > 5000
        return

      posts.forEach (post) =>
        if (Math.random() < 0.1)
          return

        score = Math.floor(post.scoreTransition.getAt(time))
        commentCount = Math.floor(post.commentCountTransition.getAt(time))
        post.elements.dislikes.innerHTML = score - 1
        post.elements.unvoted.innerHTML = score
        post.elements.likes.innerHTML = score + 1

        post.elements.comments.innerHTML = "#{commentCount} comments"

        if post.prevScore < score
          @highlightUpvote(post)
        else if post.prevScore > score
          @highlightDownvote(post)

        if post.prevCommentCount < commentCount
          @highlightCommentCountChange(post)

        post.prevScore = score
        post.prevCommentCount = commentCount

      window.requestAnimationFrame(render)
    window.requestAnimationFrame(render)

}
