class CreateInterestTagRecords < ActiveRecord::Migration
  def change
    create_table :interest_tag_records do |t|
      t.integer :user_id
      t.integer :tag_id

      t.timestamps
    end
    add_index :interest_tag_records, :user_id
    add_index :interest_tag_records, :tag_id
    add_index :interest_tag_records, [:user_id, :tag_id]
  end
end
