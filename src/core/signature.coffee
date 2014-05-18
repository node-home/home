parse = (type, arg) ->
  switch type
    # TODO we might not want to allow everything to be a string
    when 'string', String
      "#{arg}" || null
    when 'integer'
      int = parseInt "#{arg}"
      if isNaN(int) then null else int
    when 'number', Number
      float = parseFloat "#{arg}" ? null
      if isNaN(float) then null else float
    else
      return type.parse arg if type.parse?
      return type arg if typeof type is 'function'
      throw new Error "Unknown type"

clean = (params, args={}) ->
  params ?= {}
  result = {}

  for key, param of params
    dirty = args[key]
    cleaned = null

    unless dirty?
      # TODO
      # - track errors
      throw new Error 'Missing Param' if param.required
      continue unless param.default?
      if typeof param.default is 'function'
        cleaned = param.default()
      else
        cleaned = param.default

    else
      # For arrays of types, check for a valid value for each and
      # return the first match. If none return a valid, throw an error.
      if param.type instanceof Array
        for type in param.type
          try
            cleaned = parse type, dirty
          catch error
            continue

          continue unless cleaned?
          break

      else
        cleaned = parse param.type, dirty

    throw new Error 'Invalid Param' unless cleaned?

    result[key] = cleaned

  result

signaturify = (params, func) ->
  ###
    TODO
    - validate params for type
    - convert convertable params
      + numbers
      + objects
  ###
  (args) ->
    func clean params, args

module.exports = {parse, clean, signaturify}
