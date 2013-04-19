require 'securerandom'
require 'openssl'
require 'base64'

class User < ActiveRecord::Base
  SALT_BYTES = 32

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
    :password_confirmation
  )

  attr_protected :hashed_password, :salt

  attr_accessor :password, :password_confirmation, :hashed_password, :salt

  before_save :hash_password

  validates_presence_of :username
  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :password

  validates_uniqueness_of :username
  validates_uniqueness_of :email

  validates_length_of :username, in: 6..24

  validates_format_of :email, 
    with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/

  def self.new_salt
    SecureRandom.base64 SALT_BYTES
  end

  def hash_password(password=nil)
    password ||= @password

    raise RuntimeError, "Password needed for hash" if password == nil

    digest = OpenSSL::Digest::SHA512.new
    digest_length = digest.digest_length
    salt = User.new_salt

    pbkdf = OpenSSL::PKCS5.pbkdf2_hmac(
      @password,
      salt,
      PBKDF_ITERATIONS,
      digest_length,
      digest
    )

    @salt = salt
    @hashed_password = Base64.encode64 pbkdf
  end

  def slow_equals(a, b)
    raise RuntimeError unless a.kind_of? String
    raise RuntimeError unless b.kind_of? String

    is_match = true

    a_bytes = a.bytes
    b_bytes = b.bytes

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
end
