App.global_chat = App.cable.subscriptions.create {
    channel: "ConversationChannel"
    conversation_id: ''
  },
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Data received
    unless data.content.blank?
      $('#messages-box').append '<div class="card">' +
        '<div class="card-block">' + '<div class="row">'+ 
        '<div class="col-md-11">' + '<p class="card-text">' +
        '<span class="text-muted">' + data.user.first_name + 
        " at " + data.timestamp + "says " + '</span><br>' +
        data.content + '</p>' + '</div>' + '</div>' + '</div>' +
        '</div>'

  send_message: (message, conversation_id) ->
    @perform 'send_message', message: message, conversation_id: conversation_id

# jQuery(document).on 'turbolinks:load', ->
  # messages = $('#messages-box')
  # if messages.length > 0
  #   messages_to_bottom = -> messages.scrollTop(messages.prop("scrollHeight"))

  #   messages_to_bottom()