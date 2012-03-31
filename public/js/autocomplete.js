/* DO NOT MODIFY. This file was compiled Sat, 31 Mar 2012 19:11:25 GMT from
 * /Users/justin/work/documents/coffee/autocomplete.coffee
 */

(function() {

  $(function() {
    var $, Keys, drawSearchResults, handleShortcuts, resetSearchResults, search, select, setupSearchResults, verifyAndRecordNames;
    $ = jQuery;
    Keys = {
      tab: 9,
      up: 38,
      down: 40,
      comma: 188
    };
    search = function(text, people) {
      var bundled, email_match, formatted, match, match_substr, matches, name_match, person, re, _i, _j, _len, _len2, _ref;
      matches = [];
      re = new RegExp(text, "i");
      for (_i = 0, _len = people.length; _i < _len; _i++) {
        person = people[_i];
        name_match = person.name.match(re);
        email_match = person.email.match(re);
        _ref = [name_match, email_match];
        for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
          match = _ref[_j];
          if (match && match[0].length !== 0) {
            match_substr = match[0];
            formatted = match.input.replace(match_substr, match_substr.bold());
            bundled = {
              formatted: formatted,
              name: person.name,
              email: person.email
            };
            matches.push(bundled);
          }
        }
      }
      return matches;
    };
    setupSearchResults = function(parent, results, hidden) {
      var $div, parentOffset;
      if (hidden == null) hidden = true;
      $div = $('<div id="search-results" style="width: 100px; height: 100px; background-color: red; position: absolute;"><ul></ul></div>');
      parentOffset = parent.offset();
      $div.hide();
      $div.offset({
        top: parentOffset.top + parent.height() + 20,
        left: parentOffset.left
      });
      $div.width(parent.width());
      parent.after($div);
      return $div;
    };
    drawSearchResults = function(config, results) {
      var $li, result, searchResultsDiv, _i, _len, _results;
      searchResultsDiv = config['searchDiv'];
      searchResultsDiv.show();
      searchResultsDiv.find('ul').empty();
      _results = [];
      for (_i = 0, _len = results.length; _i < _len; _i++) {
        result = results[_i];
        $li = $("<li>" + result.formatted + "</li>");
        $li.attr('data-name', result.name);
        $li.attr('data-email', result.email);
        _results.push(searchResultsDiv.find('ul').append($li));
      }
      return _results;
    };
    resetSearchResults = function(config, textField) {
      var searchResultsDiv;
      searchResultsDiv = config['searchDiv'];
      searchResultsDiv.find('ul').empty();
      searchResultsDiv.hide();
      return textField.attr('data-search-results-shown', false);
    };
    select = function(textField, config) {
      var char, comma, cursorLoc, fragment, index, oldVal, person, recipients, selected;
      selected = config['searchDiv'].find('ul').children().first();
      person = selected.text();
      oldVal = textField.val();
      if (config['multiple']) {
        if (!oldVal.match(/,/)) {
          textField.val(person + ", ");
        } else {
          cursorLoc = oldVal.length;
          char = null;
          index = cursorLoc;
          comma = false;
          while (index > 0) {
            char = oldVal.charAt(index);
            if (char === ',') {
              comma = true;
              break;
            } else {
              index -= 1;
            }
          }
          fragment = oldVal.substring(index + 2, cursorLoc);
          textField.val(oldVal.replace(fragment, person + ", "));
        }
      } else {
        textField.val(person);
        textField.data('value', person);
        textField.trigger('value:set', person);
      }
      recipients = textField.data('recipients');
      recipients || (recipients = []);
      recipients.push({
        name: selected.data('name'),
        email: selected.data('email')
      });
      textField.data('recipients', recipients);
      return resetSearchResults(config, textField);
    };
    handleShortcuts = function(parent, ev, config) {
      var completing;
      completing = JSON.parse(parent.attr('data-search-results-shown'));
      if (completing) {
        switch (ev.keyCode) {
          case Keys.tab:
            ev.preventDefault();
            return select(parent, config);
        }
      }
    };
    verifyAndRecordNames = function(parent, config) {
      var name, split;
      if (config['multiple']) {
        return split = $.trim(parent.val().split(','));
      } else {
        return name = parent.val();
      }
    };
    return $.fn.autocomplete = function(config) {
      var people,
        _this = this;
      if (config == null) config = {};
      if (!(config['multiple'] != null)) config['multiple'] = true;
      config['dataSource'] || (config['dataSource'] = this);
      people = JSON.parse(config['dataSource'].attr('data-people'));
      this.attr('data-search-results-shown', false);
      config['searchDiv'] = $(setupSearchResults(this));
      return this.on({
        'keydown': function(ev) {
          return handleShortcuts(_this, ev, config);
        },
        'keyup': function(ev) {
          var char, comma, cursorLoc, index, query, results, text;
          text = $(ev.target).val();
          if (config['multiple']) {
            cursorLoc = _this[0].selectionStart || 0;
            char = null;
            index = cursorLoc;
            comma = false;
            while (index > 0) {
              char = text.charAt(index);
              if (char === ',') {
                comma = true;
                break;
              } else {
                index -= 1;
              }
            }
            if (comma) {
              query = $.trim(text.substring(index + 1));
              results = search(query, people, config);
            } else {
              results = search(text, people, config);
            }
            if (results.length === 0) {
              return resetSearchResults(config, _this);
            } else {
              drawSearchResults(config, results);
              return _this.attr('data-search-results-shown', true);
            }
          } else {
            if (config['shouldSearch']($(_this))) {
              results = search(text, people, config);
              if (results.length === 0) {
                return resetSearchResults(config, _this);
              } else {
                drawSearchResults(config, results);
                return _this.attr('data-search-results-shown', true);
              }
            }
          }
        },
        'focusin': function(ev) {
          return _this.removeData('selected-person');
        },
        'focusout': function(ev) {
          return resetSearchResults(config, _this);
        }
      });
    };
  });

}).call(this);
