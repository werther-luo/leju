class CreateSignedAddresses < ActiveRecord::Migration
  def change
    create_table :signed_addresses do |t|
      t.float :lat
      t.float :lng
      t.integer :user_id
      t.integer :state

      t.timestamps
    end
  end
end
