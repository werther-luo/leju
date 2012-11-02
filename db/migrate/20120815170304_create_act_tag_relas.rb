class CreateActTagRelas < ActiveRecord::Migration
  def change
    create_table :act_tag_relas do |t|
      t.integer :activity_id
      t.integer :tag_id

      t.timestamps
    end
    add_index :act_tag_relas, :activity_id
    add_index :act_tag_relas, :tag_id
    add_index :act_tag_relas, [:activity_id, :tag_id], unique: true
  end
end
