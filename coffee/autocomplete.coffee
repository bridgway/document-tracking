$ ->
  $ = jQuery

  search = (text, people) ->
    matches = []
    re = new RegExp(text, "i")
    for person in people
      name_match = person.name.match re
      email_match = person.email.match re
      for match in [name_match, email_match]
        if match and match[0].length != 0
          match_substr = match[0]
          formatted = match.input.replace(match_substr, match_substr.bold())
          matches.push formatted

    matches

  setupSearchResults = (parent, results, hidden=true) ->
    $div = $('<div id="search-results" style="width: 100px; height: 100px; background-color: red; position: absolute;"><ul></ul></div>')
    parentOffset = parent.offset()

    $div.hide()

    $div.offset
      top: parentOffset.top + parent.height() + 20
      left: parentOffset.left

    $div.width parent.width()
    $('body').append $div

  drawSearchResults = (searchResultsDiv, results) ->
    searchResultsDiv.show()
    searchResultsDiv.find('ul').empty()

    for result in results
      $li = $("<li>#{result}</li>")
      searchResultsDiv.find('ul').append $li

  resetSearchResults = (el) ->
    $('#search-results').find('ul').empty()
    $('#search-results').hide()

    el.attr 'data-search-results-shown', false

  $.fn.autocomplete = ->
    # *this* is the object that's being autocompleted.

    people = JSON.parse this.attr('data-people')

    this.attr('data-search-results-shown', false)

    # get the search results div on the DOM, hidden for now.
    setupSearchResults this

    this.on
      'keyup': (ev) =>
        text = $(ev.target).val()
        results = search(text, people)
        if results.length == 0
          resetSearchResults(this)
        else
          drawSearchResults $('#search-results'), results
          this.attr 'data-search-results-shown', true

      'focusout': (ev) =>
        resetSearchResults this