class AddActiveToCertificates < ActiveRecord::Migration
  def change
    add_column :certificates, :active, :boolean
  end
end
