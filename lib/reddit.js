
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
      var data, response;
      if (xhr.status === 200) {
        response = JSON.parse(xhr.responseText);
        data = response.data;
        if (data.children) {
          data.children = data.children.map(function(node) {
            return node.data;
          });
          callback(data);
        } else {
          callback(response);
        }
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
  user: function(callback) {
    return this.request('/user.json', callback);
  }
};
