class CreateUserAcRelas < ActiveRecord::Migration
  def change
    create_table :user_ac_relas do |t|
      t.integer :user_id
      t.integer :activity_id

      t.timestamps
    end
    add_index :user_ac_relas, :user_id
    add_index :user_ac_relas, :activity_id
    add_index :user_ac_relas, [:user_id, :activity_id], unique: true
  end
end
