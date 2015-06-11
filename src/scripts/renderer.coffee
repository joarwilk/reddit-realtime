ScoreTransition = require '../lib/transitions/score'

module.exports = {
  commentTree: (element, comments, doc) ->
    doc = document.createDocumentFragment() unless doc?

    root = doc.createElement('div')
    #for comment in comments
      # do nothing

  listing: (posts) ->
    listing = Array::slice.call(document.querySelectorAll('.thing.link'))

    posts.forEach (post, i) ->
      elem = document.querySelector('[data-fullname="' + post.name + '"]')
      if elem
        elements = {
          dislikes: elem.querySelector('.score.dislikes')
          unvoted: elem.querySelector('.score.unvoted')
          likes: elem.querySelector('.score.likes')
        }

        startScore = parseInt(elements.unvoted.innerHTML)
        startScore = post.score if isNaN startScore
        transition = new ScoreTransition(startScore, post.score, 5000)

        id = 0
        asd = 0
        interval = Math.random() * 500

        window.requestAnimationFrame()
        id = setInterval( () ->
          time = asd++ * interval

          if time > 5000
            clearInterval id
            return

          score = Math.floor(transition.getAt(time))
          elements.dislikes.innerHTML = score - 1
          elements.unvoted.innerHTML = score
          elements.likes.innerHTML = score + 1
        , interval)
        elem.querySelector('.comments').innerHTML = "#{post.num_comments} comments"
      else
        console.info 'new thing - ', post.title


        #if document.querySelector('#siteTable').indexOf(elem) > i
          #do

}
