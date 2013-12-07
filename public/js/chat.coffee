$(document).ready ->
  NUMBER_OF_BG_IMAGES = 11

  app = window || {}

  app.ChatModel = Backbone.Model.extend
    defaults:
      clients: []
      chats: ["Enter a username"]

    updateModel: (chatModel) ->
      @set('clients', chatModel.clients)
      @set('chats', chatModel.chats)
      @trigger('updated')

  app.ChatView = Backbone.View.extend
    el: $ '#chatBlock'

    initialize: ->
      @model = new app.ChatModel { chats: ["Enter a username"], clients: [""] }
      @model.on 'updated', @render, @

      @chatTextArea = $('#chatTextArea')
      @chatInput = $('#chatInput')
      @chatClientArea = $('#chatClients')

      @chatInput.val("anon")

    events:
      'click #chatButton': 'sendChat'
      'keypress #chatInput': 'checkForEnter'

    sendChat: ->
      line = @chatInput.val()
      @chatInput.val('')

      nickNameReg = /\/nick (.*?)$/i
      
      if nickNameReg.exec(line)?
        newNickName = nickNameReg.exec(line)[1]
        socket.emit 'chat:nick', newNickName
      else
        @chatInput.val('')
        socket.emit('chat:sendChat', line)

    checkForEnter: (e) ->
      if (e.keyCode == 13 and @chatInput.val() != "")
        @sendChat()

    displayClients:->
      @chatClientArea.html("")
      for client in _.values @model.get('clients')
        @chatClientArea.append("<li> #{ client } </li>")

    render: ->
      @chatTextArea.val(@model.get('chats').join("\n"))
      @displayClients()
      @

  # Socket.io crap
  socket = io.connect()

  socket.on 'chat:update', (data) ->
    app.chatView.model.updateModel(data)
