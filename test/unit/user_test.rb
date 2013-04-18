require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_uniqueness_of :username
  should validate_uniqueness_of :email
  should ensure_length_of(:username).is_at_least(6).is_at_most(24)
end
