$ ->

  class ProgressBar
    MAX = 124

    constructor: (id, draw = false) ->
      @el = $(id)
      @canvas = Raphael @el[0]

      if draw
        this.draw()

    draw: ->
      @outerWidth = @el.width() - 6

      outer = @canvas.rect(5, 10, @outerWidth, 23, 15)

      outer.attr 'stroke', '#9EACB0'
      outer.attr 'stroke-width', '2'

      inner = @canvas.rect(10, 14, 0, 15, 10)
      inner.attr 'fill', '#9EACB0'
      inner.attr 'stroke', '#9EACB0'

      @inner = inner

    tick: ->
      width = @inner.attr 'width'
      newWidth = width + 20

      if newWidth >= MAX
        diff = MAX - newWidth
        @inner.attr 'width', diff + newWidth
      else
        @inner.attr 'width', newWidth

    start: ->
      this.tick()

  window.ProgressBar = ProgressBar
