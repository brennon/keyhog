class User < ActiveRecord::Base
  attr_accessible :email, :username

  validates_uniqueness_of :username
  validates_uniqueness_of :email

  validates_length_of :username, in: 6..24
end
