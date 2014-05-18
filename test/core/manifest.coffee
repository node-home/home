{manifest, minifest} = require '../../src/core/manifest'

describe 'core', ->
  describe 'manifest', ->
    example =
      options:
        name: "Test"
        info: "Info"
        url:  "//localhost/example"
      extensions:
        extension:
          name: 'Extension'
          url:  '//localhost/example/extension'
          info: 'Extension info'

    describe '.minifest()', ->
      it 'should return just name and url', ->
        minifest(example).should.containEql
          name: "Test"
          url:  "//localhost/example"
        minifest(example).should.not.have.properties 'info', 'extensions'

      it 'should return undefined values if missing', ->
        minifest({}).should.containEql
          name: undefined
          url:  undefined

    describe '.manifest()', ->
      it 'should return a manifest', ->
        manifest(example).should.containDeep
          name: "Test"
          info: "Info"
          url:  "//localhost/example"
          extensions:
            extension:
              name: 'Extension'
              url:  '//localhost/example/extension'

      it 'should return nested minifest', ->
        manifest(example).should.not.containDeep
          extensions:
            extension:
              info: 'Extension info'
