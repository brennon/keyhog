require 'securerandom'
require 'openssl'
require 'base64'

class User < ActiveRecord::Base
  SALT_BYTES = 64

  if Rails.env == 'test'
    PBKDF_ITERATIONS = 1
  else
    PBKDF_ITERATIONS = 20000
  end

  attr_accessible(
    :email, 
    :username, 
    :first_name, 
    :last_name, 
    :password, 
    :password_confirmation,
  )

  attr_accessor :password, :password_confirmation

  has_many :certificates

  before_save :update_hashed_password

  validates_presence_of :username
  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :password
  validates_presence_of :password_confirmation
  validates_confirmation_of :password

  validates_uniqueness_of :username
  validates_uniqueness_of :email

  validates_length_of :username, in: 6..24

  validates_format_of :email, 
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/

  validate :check_password_requirements

  def check_password_requirements
    unless @password =~ /.*?[a-z].*?[a-z].*?/
      errors.add :password, 'must contain at least two lowercase letters'
    end

    unless @password =~ /.*?[A-Z].*?[A-Z].*?/
      errors.add :password, 'must contain at least two uppercase letters'
    end

    unless @password =~ /.*?\d.*?\d.*?/
      errors.add :password, 'must contain at least two numbers'
    end

    unless @password =~ /.*?\W.*?\W.*?/
      errors.add :password, 'must contain at least two special characters'
    end
  end

  def update_hashed_password
    result = self.hash_password(@password)
    self.salt = result[:salt]
    self.hashed_password = result[:hashed_password]
  end

  def self.new_salt
    SecureRandom.base64 SALT_BYTES
  end

  def hash_password(password = nil, salt = nil)
    password ||= @password
    salt ||= User.new_salt

    raise RuntimeError, "Password needed for hash" if password == nil

    ENV['ARMOR_ITER'] = '1000'
    digest = Armor.digest(password.to_s, salt.to_s)

    return { salt: salt, hashed_password: digest }
  end

  def slow_equals(a, b)
    raise RuntimeError unless a.kind_of? String
    raise RuntimeError unless b.kind_of? String

    is_match = true

    a_bytes = a.bytes.to_a
    b_bytes = b.bytes.to_a

    if a_bytes.count < b_bytes.count
      count = a_bytes.count
    else
      count = b_bytes.count
    end

    for i in 0..(count-1) do
      is_match = false if a_bytes[i] != b_bytes[i]
    end

    is_match = false unless a_bytes.count == b_bytes.count
    is_match
  end

  def validate_password(input = nil)
    raise RuntimeError if !input

    hashed_input = hash_password(input, self.salt)
    slow_equals(hashed_input[:hashed_password], self.hashed_password) 
  end
end
