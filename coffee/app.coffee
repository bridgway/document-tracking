$ ->
  class window.Document extends Backbone.Model

  class window.DocumentView extends Backbone.View
    template: Handlebars.compile $("#document-template").html()

    initialize: (document) ->
      this.model = document
      this.model.on 'change:file', this.fileChanged, this
      this.render()

    fileChanged: (args...) ->
      uploadForm.$el.fadeOut()
      console.log this.render().$el
      $('#upload').append(this.render().$el)

    render: ->
      this.$el.html this.template this.model.toJSON()
      this


  class window.DocumentUploadForm extends Backbone.View
    el: $('#upload-form')
    initialize: (model) ->
      this.model = model

      # Bind our fileupload handler to the drop zone.

      $('#drop').fileupload
        dataType: 'json'
        dropZone: $('#drop')
        url: '/upload'
        # have to wrap it in the anonymous function to keep track of this.
        done: (ev, data) => this.handleUpload(ev, data)

    handleUpload: (ev, data) ->
      _.each data.result, (file, index) =>
        plucked = name: file.name, thumbnail_url: file.thumbnail_url
        @model.set file: plucked

  window.currentDocument = new Document
  window.uploadForm = new DocumentUploadForm(currentDocument)
  window.documentView = new DocumentView(currentDocument)