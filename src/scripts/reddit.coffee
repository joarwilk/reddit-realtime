###

API Requester

###
module.exports =
  request: (path, callback) ->
    if path[0] != '/'
      throw new TypeError

    xhr = new XMLHttpRequest()
    xhr.open 'GET', "//rl.reddit.com#{path}", true
    xhr.setRequestHeader 'Content-Type', 'application/json'

    xhr.onload = ->
      if xhr.status == 200
        response = JSON.parse(xhr.responseText)
        callback(response.data)
      return
    xhr.send()

  frontpage: (type, callback) ->
    @request("/#{type}.json", callback)

  subreddit: (type, subname, callback) ->
    @request("/r/#{subname}/#{type}.json", callback)

  messages: (callback) ->
    @requestApi('/user/messages', callback)