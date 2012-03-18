$ ->
  class window.Document extends Backbone.Model

  class window.DocumentView extends Backbone.View
    template: Handlebars.compile $("#document-template").html()

    initialize: (document) ->
      this.model = document
      this.model.on 'change:file', this.fileChanged, this
      this.render()

    fileChanged: (args...) ->
      # uploadForm.$el.fadeOut()
      # console.log this.render().$el
      # $('#upload').append(this.render().$el)

    render: ->
      this.$el.html this.template this.model.toJSON()
      this


  class window.DocumentUploadForm extends Backbone.View
    el: $('#upload-form')

    initialize: (model) ->
      @model = model
      @thumbnailList = $('#document-thumbnails')
      @noFiles = true

      # Bind our fileupload handler to the drop zone.

      $('#drop').fileupload
        dataType: 'json'
        dropZone: $('#drop')
        url: '/upload'

        add: (ev, data) =>
          this.switchToUploading()
          data.submit()

        # have to wrap it in the anonymous function to keep track of this.
        done: (ev, data) => this.uploadFinished(ev, data)

    drawThumbnail: ->
      @thumbnailList.append $("<li><img src='http://placehold.it/160x200' /></li>")

    switchToUploading: (fn) ->
      if @noFiles
        $('#drop').animate height: '50px', 500, ->
          fn() if fn

        @noFiles = false

      $('#drop h2').text('Uploading...')
      $('#drop h2').animate(marginTop: '20px')

    reset: ->
      $('#drop h2').text("+ Upload a File")

    uploadFinished: (ev, data) ->
      _.each data.result, (file, index) =>
        plucked = name: file.name, thumbnail_url: file.thumbnail_url
        @model.set file: plucked
        this.drawThumbnail()
        this.reset()

  window.currentDocument = new Document
  window.uploadForm = new DocumentUploadForm(currentDocument)
  window.documentView = new DocumentView(currentDocument)