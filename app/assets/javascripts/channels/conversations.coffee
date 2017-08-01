$ ->
  hidden_field = $('.hidden_conversation')
  
  if hidden_field.text().length > 0
    App.private_chat = App.cable.subscriptions.create {
        channel: "ConversationChannel"
        conversation_id: hidden_field.text()
      },
      connected: ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        # Data received
        if data.content
          $('#messages-box').append '<div class="card">' +
            '<div class="card-block">' + '<div class="row">'+ 
            '<div class="col-md-11">' + '<p class="card-text">' +
            '<span class="text-muted">' + data.first_name + ' at ' +
            data.timestamp + ' says ' + '</span><br>' +
            data.content + '</p>' + '</div>' + '</div>' + '</div>' +
            '</div>'
          $('#submit-message').removeAttr("disabled")
          $('#message_content').val('')
          box = $('#messages-box')
          if box.length > 0
            box[0].scrollTop = box[0].scrollHeight;

      send_message: (message, conversation_id) ->
        @perform 'send_message', message: message, conversation_id: conversation_id