class SwitchPasswordDigestBackToHashedPassword < ActiveRecord::Migration
  def change
    rename_column :users, :password_digest, :hashed_password
  end
end
