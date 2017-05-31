
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
                console.log(data);
                var user = data.user
                var data = data.data
                console.log("received");
                console.log(data)
                return $(".tasks-list").append(this.appendTask(data, user));
            } else if (data.action == "destroy") {
                console.log("need to delete");
                var data = data.data
                return $("#task-" + data.id).remove();
            } else if (data.action == "update") {
                var updateType = data.update_type;
                if (updateType == "completion") {
                    var data = data.data
                    return this.taskCompletion(data)
                } else if (updateType == "priority") {
                    return
                }else {
                    console.log("should not happen");
                }
            } else {
                console.log("should not happen");
            }
        }, 

        appendTask: function(data, user) {
            var labels = this.taskLabels(data, user)
            completionButton = '<a class="btn btn-success" rel="nofollow" data-method="put" href="' + this.groupTaskPath(data, "?completed=true") + '">Complete task!</a>'
            var deleteButton = '<a class="btn btn-danger" rel="nofollow" data-method="delete" href="' + this.groupTaskPath(data, "") + '">Delete task :(</a>'
            var listItem = '<li id="' + 'task-' + data.id + '" ' + 'class="task-item">' + labels + completionButton + deleteButton + '</li>'
            return listItem
            
        },

        groupTaskPath: function(data, params) {
            return '/groups/' + data.group_id + '/tasks/' + data.id + params;
        },

        taskCompletion: function(data) {
            console.log("completion")
            if (data.completed) {
                return $("#task-" + data.id + " .btn-success").removeClass("btn-success").addClass("btn-warning").attr("href", this.groupTaskPath(data, "?completed=false")).text("Un-complete task");
            } else {
                return $("#task-" + data.id + " .btn-warning").removeClass("btn-warning").addClass("btn-success").attr("href", this.groupTaskPath(data, "?completed=true")).text("Complete task!");
            };
        },

        taskLabels(data, user) {
            var name = "<h3>" + data.name + "</h3>";
            var description = "<h5>" + data.description + "</h5>";
            var taskFor = "<h5>Task for: " + user.first_name + " " + user.last_name + "</h5> "
            var taskCompleted = "<h5>Task Completed: false</h5>"
            return name + description + taskFor + taskCompleted
        }
    })
}
