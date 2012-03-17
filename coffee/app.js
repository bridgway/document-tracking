(function() {
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; }, __slice = Array.prototype.slice;

  $(function() {
    var app;
    window.App = (function() {

      __extends(App, Backbone.View);

      function App() {
        App.__super__.constructor.apply(this, arguments);
      }

      App.prototype.initialize = function() {};

      return App;

    })();
    window.Document = (function() {

      __extends(Document, Backbone.Model);

      function Document() {
        Document.__super__.constructor.apply(this, arguments);
      }

      return Document;

    })();
    window.DocumentView = (function() {

      __extends(DocumentView, Backbone.View);

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
        uploadForm.$el.fadeOut();
        console.log(this.render().$el);
        return $('#upload').append(this.render().$el);
      };

      DocumentView.prototype.render = function() {
        this.$el.html(this.template(this.model.toJSON()));
        return this;
      };

      return DocumentView;

    })();
    window.DocumentUploadForm = (function() {

      __extends(DocumentUploadForm, Backbone.View);

      function DocumentUploadForm() {
        DocumentUploadForm.__super__.constructor.apply(this, arguments);
      }

      DocumentUploadForm.prototype.el = $('#upload-form');

      DocumentUploadForm.prototype.initialize = function(model) {
        var _this = this;
        this.model = model;
        return $('#drop').fileupload({
          dataType: 'json',
          dropZone: $('#drop'),
          url: '/upload',
          done: function(ev, data) {
            return _this.handleUpload(ev, data);
          }
        });
      };

      DocumentUploadForm.prototype.handleUpload = function(ev, data) {
        var _this = this;
        return _.each(data.result, function(file, index) {
          var plucked;
          plucked = {
            name: file.name,
            thumbnail_url: file.thumbnail_url
          };
          return _this.model.set({
            file: plucked
          });
        });
      };

      return DocumentUploadForm;

    })();
    app = new App;
    window.currentDocument = new Document;
    window.uploadForm = new DocumentUploadForm(currentDocument);
    return window.documentView = new DocumentView(currentDocument);
  });

}).call(this);
