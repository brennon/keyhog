require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_uniqueness_of :username
  should validate_uniqueness_of :email
  should ensure_length_of(:username).is_at_least(6).is_at_most(24)
  should validate_format_of(:email).with('bob@example.com')
  should validate_format_of(:email).not_with('bob@example')
end
