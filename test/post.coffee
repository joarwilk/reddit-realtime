assert = require 'assert'
expect = require('chai').expect

post = require '../lib/transitions/post'

describe 'Post', ->
  describe 'from', ->
    it 'pending'