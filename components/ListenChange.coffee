noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Listen to mouse events on a DOM element'
  c.inPorts.add 'element',
    datatype: 'object'
  c.outPorts.add 'value',
    datatype: 'object'
  c.elements = []
  c.tearDown = (callback) ->
    for element in elements
      element.el.removeEventListener 'change', element.listener, false
      element.ctx.deactivate()
    c.elements = []
    do callback
  c.forwardBrackets = {}
  c.process (input, output, context) ->
    return unless input.hasData 'element'
    data =
      el: input.getData 'element'
      listener: (event) ->
        event.preventDefault()
        event.stopPropagation()
        output.send
          value: event.target.value
      ctx: context
    data.el.addEventListener 'change', data.listener, false
    c.elements.push data
    return
