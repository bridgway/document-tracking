/* DO NOT MODIFY. This file was compiled Sun, 18 Mar 2012 16:35:52 GMT from
 * /Users/justin/hacks/documents/coffee/app.coffee
 */

(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __slice = Array.prototype.slice;

  $(function() {
    window.Document = (function(_super) {

      __extends(Document, _super);

      function Document() {
        Document.__super__.constructor.apply(this, arguments);
      }

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

      DocumentUploadForm.prototype.initialize = function(model) {
        var _this = this;
        this.model = model;
        this.thumbnailList = $('#document-thumbnails');
        this.noFiles = true;
        return $('#drop').fileupload({
          dataType: 'json',
          dropZone: $('#drop'),
          url: '/upload',
          add: function(ev, data) {
            _this.switchToUploading();
            return data.submit();
          },
          done: function(ev, data) {
            return _this.uploadFinished(ev, data);
          }
        });
      };

      DocumentUploadForm.prototype.drawThumbnail = function() {
        return this.thumbnailList.append($("<li><img src='http://placehold.it/160x200' /></li>"));
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

      DocumentUploadForm.prototype.uploadFinished = function(ev, data) {
        var _this = this;
        return _.each(data.result, function(file, index) {
          var plucked;
          plucked = {
            name: file.name,
            thumbnail_url: file.thumbnail_url
          };
          _this.model.set({
            file: plucked
          });
          _this.drawThumbnail();
          return _this.reset();
        });
      };

      return DocumentUploadForm;

    })(Backbone.View);
    window.currentDocument = new Document;
    window.uploadForm = new DocumentUploadForm(currentDocument);
    return window.documentView = new DocumentView(currentDocument);
  });

}).call(this);
