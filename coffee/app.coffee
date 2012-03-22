$ ->
  if $('#document-index').length > 0
    class window.Document extends Backbone.Model
      defaults:
        files: []

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

      events:
        'submit': 'handleSubmit'

      initialize: (model) ->
        @model = model
        @thumbnailList = $('#document-thumbnails')
        @noFiles = true

        $('#name-field').autocomplete()

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
        latest = _.last @model.get('files')
        @thumbnailList.append $("<li><img src='#{latest.url}' /></li>")

      switchToUploading: (fn) ->
        if @noFiles
          $('#drop').animate height: '50px', 500, ->
            fn() if fn

          @noFiles = false

        $('#drop h2').text('Uploading...')
        $('#drop h2').animate(marginTop: '20px')

      reset: ->
        $('#drop h2').text("+ Upload a File")


      recordFile: ->
        json = JSON.stringify @model.get('files')
        this.$el.attr 'data-files', json

      uploadFinished: (ev, data) ->
        file = data.result
        @model.get('files').push file

        # might be cleaner to just past the latest file to these methods instead of using @model.
        this.drawThumbnail()
        this.recordFile()
        this.reset()

      handleSubmit: (ev) ->
        ev.preventDefault()

        # I don't like doing this here, but it saves the pain of trying
        # to keep in sync with the textfield as the user types

        recipients = this.$el.find('#name-field').val().split(',')
        people = this.$el.find('#name-field').data('people')

        finalSet = []

        for recipient in recipients
          for person in people
            if recipient.match person.name
              fullRecipient =
                id: person.id
                name: recipient
                email: person.email

              finalSet.push fullRecipient
              break

        @model.set 'recipients', finalSet
        @model.set 'message', this.$el.find('#message').val()

        $.post this.$el.attr('action'), document: JSON.stringify(@model.toJSON()), (data) ->
          console.log data

    window.currentDocument = new Document
    window.uploadForm = new DocumentUploadForm(currentDocument)
    window.documentView = new DocumentView(currentDocument)

  if $('#show-document').length > 0
    $('#add-comment').submit (ev) ->
      ev.preventDefault()

      # Loop over our fiels and zip them into a JSON object.

      obj = {}
      re = new RegExp(/(.+)\[(.+)\]/)
      for field in $('#show-document input, #show-document textarea')
        matches = re.exec $(field).attr('name')
        parent = matches[1]
        attr = matches[2]

        obj[parent] = {} if not obj[parent]?

        obj[parent][attr] = $(field).val()

      $('textarea').val('')

      $.post $('#add-comment').attr('action'), obj, (html) ->
        $emptyMessage = $('pempty')
        $emptyMessage.remove() if $emptyMessage.length > 0

        $comment = $(html)
        $('#comments').append($comment)
        $comment.hide().fadeIn()
