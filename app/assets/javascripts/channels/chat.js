document.addEventListener("turbolinks:load", function() {
    if ($(".groups.show").length > 0) {
        initiateChatChannel(gon.user_id, gon.group_id, gon.room);
    } else {
        return;
    }
});

function initiateChatChannel(userId, groupId, room) {
    console.log("Initialized chat");
    App.chat = App.cable.subscriptions.create({channel: "ChatChannel", user_id: userId, group_id: groupId, name: room}, {
        received: function(data) {
            // messageUser is the user that sent the message
            // userId is the id of the current user
            var messageUser = data.user
            var message = data.message
            var chatMessages = $(".chat-messages")
            /*
            if (messageUser.id == userId) {
                chatMessages.append(this.createMessage(messageUser, message, userId));
                return chatMessages.scrollTop(chatMessages.prop("scrollHeight"));
            } else {
                return chatMessages.append(this.createMessage(messageUser, message, userId));
            };
            */
            chatMessages.append(this.createMessage(messageUser, message, userId));
            chatMessages.scrollTop(chatMessages.prop("scrollHeight"));
        },

        createMessage: function(messageUser, message, userId) {
            var direction;
            if (messageUser.id == userId) {
                // Current user sent the message
                direction = "right";
            } else {
                direction = "left";
            }
            var userName = $("<span></span>").addClass("message-user").text(messageUser.first_name + " " + messageUser.last_name);
            var sentAgo = $("<span></span>").addClass("sent-ago").text("Just now");
            var messageHead = $("<div></div>").addClass("message-header").append([userName, sentAgo]);

            var messageText = $("<p></p>").text(message.message);
            var messageBody = $("<div></div>").addClass("message-body").append(messageText);

            var fullMessage = [messageHead, messageBody]
            var message = $("<div></div>").addClass("message").css("float", direction).append(fullMessage);
            var messageRow = $("<div></div>").addClass("message-row").append(message)
            return messageRow
        }
    })
}
