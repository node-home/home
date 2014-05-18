app = require '../../src/core/app'

home = require '../../src'

describe 'core', ->
  describe '.App', ->
    test = app module,
      uid: 'test'
      name: "Test"

    it 'should have an extensions container', ->
      test.should.have.property 'extensions'

    describe '#extension()', ->
      extension = test.extension 'test'

      it 'should return a function', ->
        (typeof extension).should.eql 'function'

      it 'should return options', ->
        extension.should.have.property 'options'

      it 'should add extension to container', ->
        test.extensions.test.should.eql extension.options

      it 'should infer plural from singular', ->
        extension.options.plural.should.eql 'tests'

      it 'should return an objects container', ->
        test.should.have.property 'tests'

      foo = extension 'foo'

      it 'should attach objects to container', ->
        test.tests.foo.should.eql foo

    describe '#init()', ->
      it 'should have an init method', ->
        test.should.have.property 'init'
        (typeof test.init).should.eql 'function'

  describe 'example', ->
    app = require '../../examples/app'

    it 'should not load extensions before init', ->
      app.should.not.have.property 'example'
      app.should.not.have.property 'examples'

    home.init()

    it 'should add `app` to apps', ->
      home.apps.should.have.property 'app'

    describe '#init()', ->
      it 'should load and init all extensions', ->
        app.should.have.property 'example'
        app.should.have.property 'examples'
