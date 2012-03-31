/* DO NOT MODIFY. This file was compiled Sat, 31 Mar 2012 19:11:25 GMT from
 * /Users/justin/work/documents/coffee/app.coffee
 */

(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __slice = Array.prototype.slice;

  $(function() {
    if ($('#document-index').length > 0) {
      window.Document = (function(_super) {

        __extends(Document, _super);

        function Document() {
          Document.__super__.constructor.apply(this, arguments);
        }

        Document.prototype.defaults = {
          files: []
        };

        return Document;

      })(Backbone.Model);
      window.DocumentView = (function(_super) {

        __extends(DocumentView, _super);

        function DocumentView() {
          DocumentView.__super__.constructor.apply(this, arguments);
        }

        DocumentView.prototype.template = Handlebars.compile($("#document-template").html());

        DocumentView.prototype.initialize = function(document) {
          this.model = document;
          this.model.on('change:file', this.fileChanged, this);
          return this.render();
        };

        DocumentView.prototype.fileChanged = function() {
          var args;
          args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        };

        DocumentView.prototype.render = function() {
          this.$el.html(this.template(this.model.toJSON()));
          return this;
        };

        return DocumentView;

      })(Backbone.View);
      window.DocumentUploadForm = (function(_super) {

        __extends(DocumentUploadForm, _super);

        function DocumentUploadForm() {
          DocumentUploadForm.__super__.constructor.apply(this, arguments);
        }

        DocumentUploadForm.prototype.el = $('#upload-form');

        DocumentUploadForm.prototype.events = {
          'submit': 'handleSubmit',
          'click #add-cc a': 'showAddCCField'
        };

        DocumentUploadForm.prototype.initialize = function(model) {
          var $nameField;
          this.model = model;
          this.thumbnailList = $('#document-thumbnails');
          this.noFiles = true;
          this.setupValidation();
          $nameField = $('#name-field');
          this.people = $nameField.data('people');
          $nameField.autocomplete({
            multiple: false,
            shouldSearch: this.shouldSearch
          });
          return $nameField.on({
            'value:set': function(ev, value) {
              return $nameField.data('selected-person', value);
            }
          });
        };

        DocumentUploadForm.prototype.getCCNames = function() {
          return _.filter($('#cc-field').val().split(','), function(element) {
            return element.replace(/\ /, '').length > 0;
          });
        };

        DocumentUploadForm.prototype.setupValidation = function() {
          var validCC, validPerson,
            _this = this;
          validPerson = function(name) {
            var names;
            names = _.pluck(_this.people, 'name');
            return _.include(names, name);
          };
          validCC = function(list) {
            var names;
            names = _this.getCCNames();
            return _.every(names, validPerson);
          };
          $.validator.addMethod('validPerson', validPerson, "Don't know who that is!");
          $.validator.addMethod('validCC', validCC, "Don't know who that is!");
          return this.$el.validate({
            ignore: false,
            rules: {
              to: {
                required: true,
                validPerson: true
              },
              cc: {
                validCC: {
                  depends: function(el) {
                    return $(el).is(':visible');
                  }
                }
              },
              file: {
                required: true,
                accept: "pdf"
              }
            },
            messages: {
              to: {
                required: "Who do you want to send the document to?",
                validPerson: "Don't know who that is."
              },
              message: "Make sure you write a message.",
              file: "Make sure you upload a PDF."
            },
            errorPlacement: function(error, el) {
              if (el.attr('name') === 'file') {
                return $('#upload').append(error);
              } else {
                return error.insertAfter(el);
              }
            },
            submitHandler: function(form) {
              return form.submit();
            }
          });
        };

        DocumentUploadForm.prototype.shouldSearch = function(el) {
          if (el.data('selected-person')) return false;
          return true;
        };

        DocumentUploadForm.prototype.drawThumbnail = function() {
          var latest;
          latest = _.last(this.model.get('files'));
          return this.thumbnailList.append($("<li><img src='" + latest.url + "' /></li>"));
        };

        DocumentUploadForm.prototype.switchToUploading = function(fn) {
          if (this.noFiles) {
            $('#drop').animate({
              height: '50px'
            }, 500, function() {
              if (fn) return fn();
            });
            this.noFiles = false;
          }
          $('#drop h2').text('Uploading...');
          return $('#drop h2').animate({
            marginTop: '20px'
          });
        };

        DocumentUploadForm.prototype.reset = function() {
          return $('#drop h2').text("+ Upload a File");
        };

        DocumentUploadForm.prototype.recordFile = function() {
          var json;
          json = JSON.stringify(this.model.get('files'));
          return this.$el.attr('data-files', json);
        };

        DocumentUploadForm.prototype.uploadFinished = function(ev, data) {
          var file;
          file = data.result;
          this.model.get('files').push(file);
          this.drawThumbnail();
          this.recordFile();
          return this.reset();
        };

        DocumentUploadForm.prototype.showAddCCField = function(ev) {
          var _this = this;
          ev.preventDefault();
          if ($('#cc-block').is(":hidden")) {
            $(ev.target).text("Remove CC");
          } else {
            $(ev.target).text("+ Add CC");
          }
          return $('#cc-block').slideToggle('fast', function() {
            return $('#cc-block').find('#cc-field').focus().autocomplete({
              dataSource: $('#name-field'),
              multiple: true,
              shouldSearch: _this.shouldSearch
            });
          });
        };

        DocumentUploadForm.prototype.handleSubmit = function(ev) {
          var finalSet, fullRecipient, people, person, recipient, recipients, _i, _j, _len, _len2;
          ev.preventDefault();
          return false;
          recipients = this.$el.find('#name-field').val().split(',');
          people = this.$el.find('#name-field').data('people');
          finalSet = [];
          for (_i = 0, _len = recipients.length; _i < _len; _i++) {
            recipient = recipients[_i];
            for (_j = 0, _len2 = people.length; _j < _len2; _j++) {
              person = people[_j];
              if (recipient.match(person.name)) {
                fullRecipient = {
                  id: person.id,
                  name: recipient,
                  email: person.email
                };
                finalSet.push(fullRecipient);
                break;
              }
            }
          }
          this.model.set('recipients', finalSet);
          this.model.set('message', this.$el.find('#message').val());
          return $.post(this.$el.attr('action'), {
            document: JSON.stringify(this.model.toJSON())
          }, function(data) {
            return console.log(data);
          });
        };

        return DocumentUploadForm;

      })(Backbone.View);
      window.currentDocument = new Document;
      window.uploadForm = new DocumentUploadForm(currentDocument);
      window.documentView = new DocumentView(currentDocument);
    }
    if ($('#show-document').length > 0) {
      return $('#add-comment').submit(function(ev) {
        var attr, field, matches, obj, parent, re, _i, _len, _ref;
        ev.preventDefault();
        obj = {};
        re = new RegExp(/(.+)\[(.+)\]/);
        _ref = $('#show-document input, #show-document textarea');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          field = _ref[_i];
          matches = re.exec($(field).attr('name'));
          parent = matches[1];
          attr = matches[2];
          if (!(obj[parent] != null)) obj[parent] = {};
          obj[parent][attr] = $(field).val();
        }
        $('textarea').val('');
        return $.post($('#add-comment').attr('action'), obj, function(html) {
          var $comment, $emptyMessage;
          $emptyMessage = $('pempty');
          if ($emptyMessage.length > 0) $emptyMessage.remove();
          $comment = $(html);
          $('#comments').append($comment);
          return $comment.hide().fadeIn();
        });
      });
    }
  });

}).call(this);
