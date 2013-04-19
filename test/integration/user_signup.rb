require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  test "Anyone can create a new user" do
    visit new_user_path
    fill_in 'First name', with: 'Bob'
    fill_in 'Last name', with: 'Thomas'
    fill_in 'Username', with: 'bthomas'
    fill_in 'Email', with: 'bob@example.com'
    click_button 'Create User'
    assert_equal user_path(User.find_by_username('bthomas')), current_path
  end
end

