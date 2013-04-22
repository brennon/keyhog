class CreateExternalSites < ActiveRecord::Migration
  def change
    create_table :external_sites do |t|
      t.string :name

      t.timestamps
    end
  end
end
