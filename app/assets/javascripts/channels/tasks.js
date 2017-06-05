document.addEventListener("turbolinks:load", function() {
    if ($(".groups.show").length > 0) {
        initiateTasksChannel(gon.user_id, gon.group_id);
    } else {
        return;
    }
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
                return this.appendTask(data, user)
            } else if (data.action == "destroy") {
                console.log("need to delete");
                var data = data.data
                return $("#task-" + data.id).remove();
            } else if (data.action == "update") {
                var updateType = data.update_type;
                if (updateType == "completion") {
                    var data = data.data
                    return this.taskCompletion(data)
                } else if (updateType == "all") {
                    console.log("update all")
                    var user = data.user
                    var data = data.data
                    return this.updateAll(data, user)
                } else {
                    console.log("should not happen");
                }
            } else {
                console.log("should not happen");
            }
        }, 

        appendTask: function(data, user) {
            var labels = this.taskLabels(data, user)
            var allLabels = $("<div></div>").addClass("task-labels").append(labels)
            var completionButton = '<a class="btn btn-success completion" data-remote="true" rel="nofollow" data-method="put" href="' + this.groupTaskPath(data, "?completed=true") + '">Complete task!</a>';
            var editButton = '<a class="btn btn-warning" href="' + this.groupTaskPath(data, "/edit") + '">Edit task</a>';
            var deleteButton = '<a class="btn btn-danger" data-remote="true" rel="nofollow" data-method="delete" href="' + this.groupTaskPath(data, "") + '">Delete task :(</a>';
            var buttons = [completionButton, editButton, deleteButton]
            var listItem = $("<li></li>").attr("id", "task-" + data.id).addClass("task-item").append(allLabels).append(buttons);
            return $(".tasks-list").append(listItem);
            
        },

        groupTaskPath: function(data, params) {
            return '/groups/' + data.group_id + '/tasks/' + data.id + params;
        },

        taskCompletion: function(data) {
            console.log("completion")
            if (data.completed) {
                $("#task-" + data.id + " .completion").removeClass("btn-success").addClass("btn-warning").attr("href", this.groupTaskPath(data, "?completed=false")).text("Un-complete task");
                return $("#task-" + data.id + " #task-completion").text("Completed: true")
            } else {
                $("#task-" + data.id + " .completion").removeClass("btn-warning").addClass("btn-success").attr("href", this.groupTaskPath(data, "?completed=true")).text("Complete task!");
                return $("#task-" + data.id + " #task-completion").text("Completed: false") }; },

        updateAll(data, user) {
            return $("#task-" + data.id + " .task-labels").html('').append(this.taskLabels(data, user));
        },

        taskLabels(data, user) {
            var name = $("<h3></h3>").text(data.name)
            var description = $("<h5></h5>").addClass("task-description").text(data.description);       
            var priority = $("<h5></h5>").addClass("task-priority").text("Priority: " + data.priority);
            var user = $("<h5></h5>").addClass("task-user").text("Task for: " + user.first_name + ' ' + user.last_name);
            var completion = $("<h5></h5>").addClass("task-completion").text("Completed: " + data.completed);
            return [name, description, priority, user, completion];
        }
    })
}
