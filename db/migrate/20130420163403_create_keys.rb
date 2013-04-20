class CreateKeys < ActiveRecord::Migration
  def change
    create_table :keys do |t|
      t.integer :user_id
      t.text :contents
      t.string :nickname
      t.string :fingerprint

      t.timestamps
    end
  end
end
