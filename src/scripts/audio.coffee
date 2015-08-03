module.exports = {
  registerSound: (soundName) =>
    # Create sound array if it hasnt been created yet
    @sounds = [] unless @sounds

    # Don't accept duplicate sounds
    sound = @sounds.filter (sound) -> sound.name == soundName
    if sound.length
      throw new Error("Sound #{soundName} already exists")

    # Create the audio element responsible for
    # playing this sound
    audioElem = document.createElement('audio')
    sourceElem = document.createElement('source')

    # Set element attributes
    audioElem.looping = false
    sourceElem.href = chrome.getUrl("/audio/#{sound}.wav")

    # Add the audio element to the page body
    document.body.appendChild(audioElem)
    audioElem.appendChild(sourceElem)

    elements = {
      audio: audioElem
      source: sourceElem
    }

    @sounds.push({
      elements: elements
      name: soundName
    })


  playSound: (soundName) =>
    # Grab the sound from our sound set
    sound = @sounds.filter (sound) -> sound.name == soundName

    sound[0].elements.audio.play()
}