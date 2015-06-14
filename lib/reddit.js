
/*

API Requester
 */
var Reddit;

Reddit = (function() {
  function Reddit() {}

  Reddit.prototype.request = function(url, callback) {
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
  };

  Reddit.prototype.frontpage = function(callback) {
    return this.request('/.json', callback);
  };

  Reddit.prototype.subreddit = function(subname, callback) {
    return this.request("/r/" + subname + "/.json", callback);
  };

  Reddit.prototype.messages = function(callback) {
    return this.requestApi('/user/messages', callback);
  };

  return Reddit;

})();

module.exports = reddit;
