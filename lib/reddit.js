
/*

API Requester
 */
module.exports = {
  request: function(path, callback) {
    var xhr;
    if (path[0] !== '/') {
      throw new TypeError;
    }
    xhr = new XMLHttpRequest();
    xhr.open('GET', "//rl.reddit.com" + path, true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.onload = function() {
      var response;
      if (xhr.status === 200) {
        response = JSON.parse(xhr.responseText);
        callback(response.data);
      }
    };
    return xhr.send();
  },
  frontpage: function(type, callback) {
    return this.request("/" + type + ".json", callback);
  },
  subreddit: function(type, subname, callback) {
    return this.request("/r/" + subname + "/" + type + ".json", callback);
  },
  messages: function(callback) {
    return this.requestApi('/user/messages', callback);
  }
};
