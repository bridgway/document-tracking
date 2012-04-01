# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#new_comment').on 'ajax:success', (e, html) ->
      $emptyMessage = $('p#empty')
      $emptyMessage.remove() if $emptyMessage.length > 0

      $comment = $(html)
      $('#comments').append($comment)
      $comment.hide().fadeIn()
