
document.addEventListener("turbolinks:load", function() {
    $('.groups.show').ready(function() {
        initiateTasksChannel(gon.user_id, gon.group_id)
    });
});

function initiateTasksChannel(userId, groupId) {
    console.log("Initialized");
    App.tasks = App.cable.subscriptions.create({channel: "TasksChannel", user_id: userId, group_id: groupId}, {
        received: function(data) {
            if (data["action"] == "create") {
                data = data["data"]
                console.log("received");
                console.log(data)
                return $(".tasks-list").append(this.appendTask(data));
            } else if (data["action"] == "delete") {
                console.log("need to delete");
                data = data["data"]
                return $("#task-" + data.id).remove()
            } else {
                console.log("should not happen");
            }
        }, 

        appendTask: function(data) {
            labels = "<h3>" + data.name + "</h3>" + "<h5>" + data.description + "</h5>"
            button = '<a class="btn btn-danger" rel="nofollow" data-method="delete" href="/groups/' + data.group_id + '/tasks/' + data.id + '">Delete task</a>'
            listItem = '<li id="' + 'task-' + data.id + '" ' + 'class="task-item">' + labels + button + '</li>'
            return listItem
            
        }
    })
}