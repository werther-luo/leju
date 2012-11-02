class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :title
      t.datetime :time_start
      t.datetime :time_end
      t.string :content
      t.string :GUID
      t.string :GUID_created_at
      t.string :back_up
      t.integer :state, :default => 0, :null => false
      t.integer :user_id
      t.timestamps
    end
    add_index :activities, [:user_id, :created_at]
  end
end
