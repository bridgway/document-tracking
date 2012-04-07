# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#updates a#clear').click (ev) ->
    ev.preventDefault()
    $.post $(ev.target).attr('href'), (data) -> console.log data
    $('#updates').fadeOut()