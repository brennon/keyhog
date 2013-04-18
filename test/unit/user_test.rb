require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should validate_uniqueness_of :username
  should validate_uniqueness_of :email
end
