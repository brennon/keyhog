object @certificate
attributes :nickname, :contents, :fingerprint, :active, :created_at, :updated_at

child :external_sites do
  attributes :name
end
