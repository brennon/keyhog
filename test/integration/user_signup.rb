require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  test "anyone can create a new user" do
    visit new_user_path
    fill_in '* First name', with: 'Bob'
    fill_in '* Last name', with: 'Thomas'
    fill_in '* Username', with: 'bthomas'
    fill_in '* Email', with: 'bob@example.com'
    fill_in '* Password', with: 'aB1!cD2@'
    fill_in '* Password confirmation', with: 'aB1!cD2@'
    click_button 'Create User'
    assert_equal user_path(User.find_by_username('bthomas')), current_path
  end

  test "registered users can log in" do
    user = FactoryGirl.create(:user)
    visit logout_path
    visit new_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log In'
    assert_equal root_path, current_path
  end
end

