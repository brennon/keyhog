object @user
attributes :username, :first_name, :last_name, :email

child :certificates do
  attributes :id, :nickname, :contents, :fingerprint, :created_at, :updated_at
end
