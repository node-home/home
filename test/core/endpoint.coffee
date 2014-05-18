endpoint = require '../../src/core/endpoint'

describe 'core', ->
  describe 'endpoint()', ->
    test = endpoint 'test', {name: 'Test'}, ->

    it 'should return a function', ->
      (typeof test).should.eql 'function'

    it 'should return an options object', ->
      test.options.should.have.keys 'url', 'method', 'name'

    it 'should return an init method', ->
      test.should.have.property 'init'
