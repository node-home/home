mongoose = require 'mongoose'
models   = require '../../src/extensions/models'

describe 'models', ->
  Model = models 'test',
    schema:
      uid: Number
      name: String

  it 'should set plural and singular'
  it 'should set or infer name'
  it 'should return a mongoose model', ->
    (new Model instanceof mongoose.Model).should.be.true

  describe 'params', ->
    it 'should support schemas'
    it 'should support methods'
    it 'should support statics'
    describe 'virtuals', ->
      it 'should support virtuals', ->
        m = models 'virtualsTest',
          virtuals:
            readOnly: ->
              'success'
            readWrite:
              get: ->
                @_test ? 'unset'
              set: (val) ->
                @_test = val

        obj = new m
        obj.readOnly.should.eql 'success'
        obj.readWrite.should.eql 'unset'
        obj.readWrite = 'set'
        obj.readWrite.should.eql 'set'

      it 'should set app uid'
      it 'should set default url', ->
        obj = new Model uid: 1
        obj.uid.should.eql 1
        obj.url.should.eql '/tests/1'

      it 'should allow custom url', ->
        obj = new (models 'customUrlTest',
          virtuals:
            url: -> '/custom'
        )
        obj.url.should.eql '/custom'

    it 'should support plugins'

