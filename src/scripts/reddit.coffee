###

API Requester

###
module.exports =
  request: (url, callback) ->
    xhr = new XMLHttpRequest()
    xhr.open 'GET', "//rl.reddit.com#{url}", true
    xhr.setRequestHeader 'Content-Type', 'application/json'

    xhr.onload = ->
      if xhr.status == 200
        response = JSON.parse(xhr.responseText)
        callback(response.data)
      return
    xhr.send()

  frontpage: (callback) ->
    @request('/.json', callback)

  subreddit: (subname, callback) ->
    @request("/r/#{subname}/.json", callback)

  messages: (callback) ->
    @requestApi('/user/messages', callback)