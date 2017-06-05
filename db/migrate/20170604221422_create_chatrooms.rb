class CreateChatrooms < ActiveRecord::Migration[5.1]
  def change
    create_table :chatrooms do |t|
      t.belongs_to :group, index: true
      t.string :name
      t.timestamps

      t.timestamps
    end
  end
end
