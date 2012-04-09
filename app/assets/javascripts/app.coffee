$ ->
  if $('#show-document').length > 0 or $('#signed').length > 0
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
        'click #add-cc a': 'showAddCCField'

      initialize: (model) ->
        @model = model
        @thumbnailList = $('#document-thumbnails')
        @noFiles = true

        this.setupValidation()

        $nameField = $('#name-field')

        @people = $nameField.data('people')

        $nameField.autocomplete multiple: false, shouldSearch: this.shouldSearch

        $nameField.on
          'value:set': (ev, value) ->
            $nameField.data 'selected-person', value

      getCCNames: -> _.filter $('#cc-field').val().split(','), (element) -> element.replace(/\ /, '').length > 0

      setupValidation: ->
        validPerson = (name) =>
          names = _.pluck @people, 'name'
          _.include names, name

        validCC = (list) =>
          names = this.getCCNames()
          _.every names, validPerson

        $.validator.addMethod 'validPerson', validPerson, "Don't know who that is!"
        $.validator.addMethod 'validCC', validCC, "Don't know who that is!"

        this.$el.validate
          # make sure we don't ignore the hidden file input.
          ignore: false

          rules:
              to:
                required: true
                validPerson: true

              cc:
                validCC:
                  depends: (el) -> $(el).is ':visible'

              file:
                required: true
                accept: "pdf"

          messages:
              to:
                required: "Who do you want to send the document to?"
                validPerson: "Don't know who that is."

              message: "Make sure you write a message."
              file: "Make sure you upload a PDF."

          errorPlacement: (error, el) ->
            if el.attr('name') is 'file'
              $('#upload').append error
            else
              error.insertAfter el

          submitHandler: (form) =>
            # Before we can submit the form, get the ids of the selected people and tack them on.

            form.submit()


      shouldSearch: (el) ->
        if el.data 'selected-person'
          return false

        true

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

        # might be cleaner to just pass the latest file to these methods instead of using @model.
        this.drawThumbnail()
        this.recordFile()
        this.reset()

      showAddCCField: (ev) ->
        ev.preventDefault()

        if $('#cc-block').is(":hidden")
          $(ev.target).text "Remove CC"
        else
          $(ev.target).text "+ Add CC"

        $('#cc-block').slideToggle 'fast', =>
          $('#cc-block').find('#cc-field').focus().autocomplete
            dataSource: $('#name-field')
            multiple: true
            shouldSearch: this.shouldSearch


      handleSubmit: (ev) ->
        ev.preventDefault()
        return false
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
