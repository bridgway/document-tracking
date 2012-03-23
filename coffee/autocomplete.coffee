$ ->
  $ = jQuery

  Keys =
    tab: 9
    up: 38
    down: 40
    comma: 188

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

          bundled =
            formatted: formatted
            name: person.name
            email: person.email

          matches.push bundled

    matches

  setupSearchResults = (parent, results, hidden=true) ->
    $div = $('<div id="search-results" style="width: 100px; height: 100px; background-color: red; position: absolute;"><ul></ul></div>')
    parentOffset = parent.offset()

    $div.hide()

    $div.offset
      top: parentOffset.top + parent.height() + 20
      left: parentOffset.left

    $div.width parent.width()
    parent.after $div
    $div

  drawSearchResults = (searchResultsDiv, results) ->
    searchResultsDiv.show()
    searchResultsDiv.find('ul').empty()

    for result in results
      $li = $("<li>#{result.formatted}</li>")
      $li.attr 'data-name', result.name
      $li.attr 'data-email', result.email

      searchResultsDiv.find('ul').append $li

  resetSearchResults = (searchResultsDiv, textField) ->
    searchResultsDiv.find('ul').empty()
    searchResultsDiv.hide()

    textField.attr 'data-search-results-shown', false

  select = (textField, searchDiv) ->
    selected = searchDiv.find('ul').children().first()
    person = selected.text()

    oldVal = textField.val()

    if not oldVal.match(/,/)
      textField.val person + ", "
    else
      cursorLoc = oldVal.length

      char = null
      index = cursorLoc
      comma = false

      while index > 0
        char = oldVal.charAt index
        if char == ','
          comma = true
          break
        else
          index -= 1

      # pad it by two
      fragment = oldVal.substring(index + 2, cursorLoc)
      textField.val oldVal.replace(fragment, person + ", ")

    recipients = textField.data('recipients')
    recipients ||= []
    recipients.push
      name: selected.data('name')
      email: selected.data('email')

    textField.data('recipients', recipients)

    resetSearchResults(searchDiv, textField)
    verifyAndRecordNames(textField, searchDiv)

  handleShortcuts = (parent, ev, searchDiv) ->
    completing = JSON.parse parent.attr 'data-search-results-shown'

    if completing
      switch ev.keyCode
        when Keys.tab
         ev.preventDefault()
         select(parent, searchDiv)

        # when Keys.up

        # when Key.down

  # TODO: Right now this thing records whitespace..  when name.length > 0 is not working..
  verifyAndRecordNames = (parent) ->
    split = $.trim parent.val().split(',')


  $.fn.autocomplete = (opts = {}) ->
    # *this* is the object that's being autocompleted.

    opts['dataSource'] ||= this

    people = JSON.parse opts['dataSource'].attr('data-people')

    this.attr('data-search-results-shown', false)

    # get the search results div on the DOM, hidden for now.
    $searchDiv = setupSearchResults this

    this.on
      'keydown': (ev) =>
        handleShortcuts(this, ev, $searchDiv)

      'keyup': (ev) =>
        text = $(ev.target).val()

        cursorLoc = this[0].selectionStart || 0

        char = null
        index = cursorLoc
        comma = false

        while index > 0
          char = text.charAt index
          if char == ','
            comma = true
            break
          else
            index -= 1

        if comma
          query = $.trim text.substring(index + 1)

          results = search(query, people, $searchDiv)
        else
          results = search(text, people, $searchDiv)

        if results.length == 0
          resetSearchResults($searchDiv, this)
        else
          drawSearchResults $searchDiv, results
          this.attr 'data-search-results-shown', true

      'focusout': (ev) =>
        resetSearchResults $searchDiv, this
        verifyAndRecordNames(this)