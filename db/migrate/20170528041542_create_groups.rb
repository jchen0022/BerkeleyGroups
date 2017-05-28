class CreateGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :course
      t.integer :size

      t.timestamps
    end
  end
end
