class ChangeKeysTableToCertificates < ActiveRecord::Migration
  def change
    rename_table :keys, :certificates
  end
end
