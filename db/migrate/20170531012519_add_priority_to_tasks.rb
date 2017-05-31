class AddPriorityToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :priority, :integer
  end
end
