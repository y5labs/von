module.exports = (transitions) ->
  map = {}
  actions = {}
  for transition in transitions
    from = transition.from
    from = [from] unless transition.from instanceof Array
    for f in from
      map[f] = {} if !map[f]
      if map[f][transition.action]?
        throw "Action #{transition.action} already available from #{f}"
      actions[transition.action] = yes
      map[f][transition.action] = transition.to
  (initialstate, callbacks) ->
    if !map[initialstate]?
      throw "#{initialstate} is not a valid state"
    callbacks ?= {}
    result =
      state: initialstate
      is: (state) -> result.state is state
      can: (action) ->
        if !map[result.state]?
          throw "#{result.state} is not a valid state"
        map[result.state][action]?
      cannot: (action) -> not result.can action
      transitions: ->
        if !map[result.state]?
          throw "#{result.state} is not a valid state"
        map[result.state]
      actions: -> Object.keys result.transitions()
    for action in Object.keys actions
      do (action) ->
        result[action] = (args...) ->
          if !map[result.state]?
            throw "#{result.state} is not a valid state"
          if !map[result.state][action]?
            throw "#{action} is not available from #{result.state}"
          to = map[result.state][action]
          if callbacks["exit#{result.state}"]?
            callbacks["exit#{result.state}"] action, result.state, to, args...
          if callbacks["on#{action}"]?
            callbacks["on#{action}"] action, result.state, to, args...
          if callbacks["enter#{to}"]?
            callbacks["enter#{to}"] action, result.state, to, args...
          result.state = to
    result
