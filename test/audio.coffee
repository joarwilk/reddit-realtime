expect = require('chai').expect

audio = require '../lib/audio'

describe 'Audio', ->
  describe 'registerSound', ->
    it 'adds another element to the collection', ->
      audio.registerSound('test')

      expect(audio.sounds).to.have.length 1

    it 'sets the correct name', ->
      audio.registerSound('test')

      expect(audio.sounds[0].name).to.equal 'test'

    it 'creates an audio element', ->
      audio.registerSound('test')

      expect(audio.sounds[0].elements.audio).to.not.be.null
