require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Required attributes
  should validate_presence_of :username
  should validate_presence_of :email
  should validate_presence_of :first_name
  should validate_presence_of :last_name

  # Unique attributes
  should validate_uniqueness_of :username
  should validate_uniqueness_of :email

  # Other validations
  should ensure_length_of(:username).is_at_least(6).is_at_most(24)
  should allow_value('bob@example.com').for(:email)
  should allow_value('bob@example.au').for(:email)
  should allow_value('bob@example.co.uk').for(:email)
  should allow_value('bob.thomas@example.com').for(:email)
  should_not allow_value('bob@example').for(:email)
  should_not allow_value('bob').for(:email)
  should_not allow_value('bob@example com').for(:email)
end
