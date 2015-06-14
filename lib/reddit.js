
/*

API Requester
 */
module.exports = {
  request: function(url, callback) {
    var xhr;
    xhr = new XMLHttpRequest();
    xhr.open('GET', "//rl.reddit.com" + url, true);
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
  frontpage: function(callback) {
    return this.request('/.json', callback);
  },
  subreddit: function(subname, callback) {
    return this.request("/r/" + subname + "/.json", callback);
  },
  messages: function(callback) {
    return this.requestApi('/user/messages', callback);
  }
};
