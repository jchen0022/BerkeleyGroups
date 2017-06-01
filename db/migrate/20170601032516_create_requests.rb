class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.belongs_to :group, index: true
      t.belongs_to :user, index: true
      t.text :description

      t.timestamps
    end
  end
end
