{parse, clean, signaturify} = require '../../src/core/signature'

describe 'core', ->
  describe 'signature', ->
    describe '.parse()', ->
      it 'should parse strings', ->
        parse(String, 'foo').should.eql 'foo'
        parse('string', 'foo').should.eql 'foo'

      it 'should discard empty strings', ->
        (null is parse('string', '')).should.be.true

      it 'should parse integers', ->
        parse('integer', '1').should.eql 1
        parse('integer', 2).should.eql 2

      it 'should discard non-integers', ->
        (null is parse('integer', 'a 1')).should.be.true
        (null is parse('integer', {})).should.be.true

      it 'should parse numbers', ->
        parse(Number, '1').should.eql 1.0
        parse('number', '2.5').should.eql 2.5

      it 'should discard non-numbers', ->
        (null is parse('number', 'a')).should.be.true
        (null is parse('number', 'a2.5')).should.be.true

      it 'should throw unknowns', ->
        (-> parse 'unknown').should.throw()

      it 'should call functions', ->
        parse(((x) -> x.foo), foo: 'bar').should.eql 'bar'

      it 'should call parse on objects that provide it', ->
        parse((parse: (x) -> x.foo), foo: 'bar').should.eql 'bar'

    describe '.clean()', ->
      params =
        optional:
          type: Number
        defaulted:
          type: String
          default: 'Default'
        array:
          type: [Number, String]

      requiredParams =
        required:
          type: String
          required: yes

      it 'should clean arguments', ->
        clean params,
          optional: 1
          defaulted: '2'
          array: '3'
        .should.containEql
          optional: 1
          defaulted: '2'
          array: 3

      it 'should throw missing required', ->
        (-> clean requiredParams).should.throw()

      it 'should omit missing non-required', ->
        clean(params).should.not.have.properties 'optional', 'array'

      it 'should default missing parameters', ->
        clean(params).should.containEql defaulted: 'Default'

      it 'should parse value with type', ->
        clean params,
          optional: 1
        .should.containEql
          optional: 1

      it 'should parse value with array of types', ->
        clean params,
          array: '3'
        .should.containEql
          array: 3

      it 'should throw invalid arguments', ->
        (-> clean params, optional: 'a').should.throw()

    describe '.signaturify()', ->
      it 'should return a function', ->
        (typeof signaturify({}, ->)).should.eql 'function'

      it 'should clean the arguments on a function call', ->
        test = signaturify
          param:
            type: String
            default: 'a'
        , ({param}) ->
          "#{param}.#{param}"

        test().should.eql 'a.a'
        test(param: 'b').should.eql 'b.b'
