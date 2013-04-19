require 'securerandom'

class User < ActiveRecord::Base
  SALT_BYTES = 32
  
  attr_accessible :email, :username, :first_name, :last_name

  validates_presence_of :username
  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name

  validates_uniqueness_of :username
  validates_uniqueness_of :email

  validates_length_of :username, in: 6..24

  validates_format_of :email, 
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/

  def self.salt
    SecureRandom.base64 SALT_BYTES
  end
end
