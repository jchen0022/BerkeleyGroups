document.addEventListener("turbolinks:load", function() {
    if ($(".groups.show").length > 0) {
        initiateChatChannel(gon.user_id, gon.group_id);
    } else {
        return;
    }
});
