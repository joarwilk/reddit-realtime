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
        data = response.data

        # Format the data slightly so the recievers
        # dont have to do it themselves
        if data.children
          data.children = data.children.map (node) -> node.data

          callback(data)
        else
          callback(response)
      return
    xhr.send()

  frontpage: (type, callback) ->
    @request("/#{type}.json", callback)

  subreddit: (type, subname, callback) ->
    @request("/r/#{subname}/#{type}.json", callback)

  user: (callback) ->
    @request('/user.json', callback)