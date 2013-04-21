require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  def login_user(user = nil)
    user ||= FactoryGirl.create(:user)
    logout_current_user
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log In'
    @user = user
  end

  def logout_current_user
    visit logout_path
  end

  def create_certificate(user = nil)
    login_user
    visit user_path(user.id)
    click_link 'Certificates'
    click_link 'New'
    fill_in '* Nickname', with: 'Primary Certificate'
    fill_in '* Content', with: 'ssh-rsa body nickname'
    click_button 'Create Certificate'
    @certificate = Certificate.last
  end

  def login_user_and_create_certificate
    login_user
    create_certificate(@user)
  end

  test "anyone can create a new user" do
    logout_current_user
    visit signup_path
    fill_in '* First name', with: 'Bob'
    fill_in '* Last name', with: 'Thomas'
    fill_in '* Username', with: 'humberto'
    fill_in '* Email', with: 'humberto@example.com'
    fill_in '* Password', with: 'aB1!cD2@'
    fill_in '* Password confirmation', with: 'aB1!cD2@'
    click_button 'Create User'
    assert_equal user_path(User.last.id), current_path
  end

  test "registered users can log in" do
    login_user
    assert_equal root_path, current_path
  end

  test "logged-in users see the correct menu" do
    login_user
    assert !page.has_content?('Log In')
    assert !page.has_content?('Sign Up')
    assert page.has_content?('Profile')
    assert page.has_content?('Certificates')
  end

  test "logged-in users can log out" do
    login_user
    visit logout_path
    assert page.has_content?('Logged out!')
    assert page.has_content?('Log In')
    assert !page.has_content?('Log Out')
    assert !page.has_content?('Certificates')
  end

  test "a logged-in user can create a certificates" do
    login_user_and_create_certificate
    assert_equal user_certificate_path(@user, Certificate.last), current_path
    assert page.has_content?('Certificate was successfully created.')
  end

  test "a logged-in user can view their certificates" do
    login_user_and_create_certificate
    click_link 'Certificates'
    assert page.has_content?('Primary Certificate')
  end

  test "a logged-in user can view a certificate" do
    login_user_and_create_certificate
    visit user_certificates_path(@user)
    click_link 'Primary Certificate'
    assert page.has_content?('Primary Certificate')
  end

  test "a logged-in user can edit a certificate" do
    login_user_and_create_certificate
    visit edit_user_certificate_path(@user, @certificate)
    fill_in '* Nickname', with: 'Updated Certificate'
    fill_in '* Contents', with: 'ssh-dsa body nickname'
    click_button 'Update Certificate'
    assert_equal user_certificate_path(@user, @certificate), current_path
    assert page.has_content?('Certificate was successfully updated.')
  end
end

