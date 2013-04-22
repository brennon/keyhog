class CreateSiteAuthorizations < ActiveRecord::Migration
  def change
    create_table :site_authorizations do |t|
      t.integer :certificate_id
      t.integer :external_site_id

      t.timestamps
    end
  end
end
