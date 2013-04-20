class Key < ActiveRecord::Base
  attr_accessible :contents, :fingerprint, :nickname, :user_id
end
