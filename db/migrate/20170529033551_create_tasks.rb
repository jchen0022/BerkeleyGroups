class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.boolean :completed, default: false
      t.belongs_to :user, index: true, optional: true
      t.belongs_to :group, index: true, optional: true

      t.timestamps
    end
  end
end
