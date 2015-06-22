module.exports = {
  registerSound: (function(_this) {
    return function(soundName) {
      var audioElem, elements, sound, sourceElem;
      if (!_this.sounds) {
        _this.sounds = [];
      }
      sound = _this.sounds.filter(function(sound) {
        return sound.name === soundName;
      });
      if (sound) {
        throw new ArgumentError("Sound " + soundName + " already exists");
      }
      audioElem = document.createElement('audio');
      sourceElem = document.createElement('source');
      audioElem.looping = false;
      sourceElem.href = chrome.getUrl("/audio/" + sound + ".wav");
      document.body.appendChild(audioElem);
      audioElem.appendChild(sourceElem);
      elements = {
        audio: audioElem,
        source: sourceElem
      };
      return _this.sounds.push({
        elements: elements,
        name: soundName
      });
    };
  })(this),
  playSound: (function(_this) {
    return function(soundName) {
      var sound, url;
      sound = _this.sounds.filter(function(sound) {
        return sound.name === soundName;
      });
      return url = _this.source.setAttribute('href', url);
    };
  })(this)
};
