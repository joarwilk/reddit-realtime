ScoreTransition = require '../lib/transitions/score'

module.exports = {
  commentTree: (element, comments, doc) ->
    doc = document.createDocumentFragment() unless doc?

    root = doc.createElement('div')
    #for comment in comments
      # do nothing

  getListing: () ->
    return Array::slice.call(document.querySelectorAll('#siteTable > .thing.link'))

  insertRealtimeToggleButton: () ->
    button = document.createElement('button')
    button.id = 'toggle-realtime'
    button.innerHTML = 'TOGGLE'

    document.querySelector('#header-bottom-right').appendChild(button)

    return button

  swapListElements: (first, second) ->
    first.classList.add('swapping')
    second.parentNode.insertBefore(first, second.nextSibling)

  insertListElement: (post, index) ->
    root = post.elements.root
    root.classList.add('inserting')

    ref = @getListing()[index]
    ref.parentNode.insertBefore(root, ref.nextSibling)

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

  highlightKarmaCountChange: (score, isCommentScore) ->



  updateListItem: (postListItem) ->
    postListItem.elements.unvoted.innerHTML =  postListItem.score

  createListElementFromPost: (post) ->
    # Function moved to reduce the char count of some lines
    clickFunc = '$(this).vote(r.config.vote_hash, null, event)'

    elem = document.createElement('div')
    elem.innerHTML =
      """
      <div class="thing inserted id-#{post.id} odd link"
        data-fullname="#{post.id}" onclick= "click_thing(this)">
        <p class="parent">
        </p>
        <span class="rank">0</span>

        <div class="midcol unvoted">
          <div class="arrow up login-required"
            onclick="#{clickFunc}" tabindex="0">
          </div>


          <div class="score dislikes">
            #{post.score - 1}
          </div>


          <div class="score unvoted">
            #{post.score}
          </div>


          <div class="score likes">
            #{post.score + 1}
          </div>


          <div class="arrow down login-required" onclick=
          "#{clickFunc}" tabindex="0">
          </div>
        </div>
        <a class="thumbnail may-blank loggedin" href=
        "#{post.url}"><img alt="" height="70" src=
        "#{post.thumbnail}"
        width="70"></a>

        <div class="entry unvoted lcTagged">
          <p class="title"><a class="title may-blank loggedin srTagged imgScanned"
          href="#{post.url}" id="img3" name="img3" tabindex="1"
          type="IMAGE">#{post.title}</a> <span class="domain">(<a href=
          "/domain/#{post.domain}">#{post.domain}</a>)</span></p>
          <a class=
          "toggleImage expando-button collapsed collapsedExpando image linkImg">&nbsp;</a>

          <p class="tagline">submitted <time class="live-timestamp" datetime=
          "2015-06-11T11:09:17+00:00" title="Thu Jun 11 11:09:17 2015 UTC">2 hours
          ago</time> by
          <a class="author may-blank id-t2_o1att userTagged"
            href="http://www.reddit.com/user/#{post.user}">#{post.user}</a><span class="RESUserTag"><a class="userTagLink RESUserTagImage"
          href="javascript:void(0)" title="set a tag"></a></span> <a class=
          "voteWeight" href="javascript:void(0)" style=
          "display: none;">[vw]</a><span class="userattrs"></span> to <a class=
          "subreddit hover may-blank" href=
          "http://www.reddit.com/r/Stuff/">/r/Stuff</a></p>


          <ul class="flat-list buttons">
            <li class="first">
              <a class="comments may-blank" href=
              "http://www.reddit.com/r/Stuff/comments/39fhvl/bad_luck_ellen/">#{post.num_comments}
              comments</a>
            </li>


            <li class="share">
              <a class="post-sharing-button" href="javascript:%20void%200;">share</a>
            </li>


            <li class="link-save-button save-button">
              <a href="#">save</a>
            </li>


            <li>
              <form action="/post/hide" class="state-button hide-button" method=
              "post">
                <input name="executed" type="hidden" value="hidden"><span><a href=
                "javascript:void(0);">hide</a></span>
              </form>
            </li>


            <li class="report-button">
              <a class="action-thing" data-action-form="#report-action-form" href=
              "javascript:void(0)">report</a>
            </li>


            <li><span class="redditSingleClick">[l+c]</span>
            </li>
          </ul>


          <div class="expando" style="display: none">
            <span class="error">loading...</span>
          </div>
        </div>


        <div class="child">
        </div>


        <div class="clearleft">
        </div>
      </div>"""

    return elem
}