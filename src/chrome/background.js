/***

 This script exists purely for User Agent spoofing

 ***/

chrome.webRequest.onBeforeSendHeaders.addListener(
    function(info) {
        // Replace the User-Agent header
        var headers = info.requestHeaders;
        headers.forEach(function(header, i) {
            console.info(header.name)
            if (header.name == 'User-Agent') {
                header.value = 'Realtime Reddit v0.1 by /u/Glorious-G';
            }
        });
        return {
            requestHeaders: headers
        };
    },
    {
        urls: [
            "*://rl.reddit.com/*",
        ]
    },
    ["blocking", "requestHeaders"]
);