class CreateActPhotoRelas < ActiveRecord::Migration
  def change
    create_table :act_photo_relas do |t|
      t.integer :activity_id
      t.integer :photo_id

      t.timestamps
    end
    add_index :act_photo_relas, :activity_id
    add_index :act_photo_relas, :photo_id
    add_index :act_photo_relas, [:activity_id, :photo_id], unique: true
  end
end
