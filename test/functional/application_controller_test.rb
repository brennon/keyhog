require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  setup do
  end

  test ":current_user should return the logged-in user" do
    user = FactoryGirl.create(:user)
    app_controller = @controller
    @controller = SessionsController.new
    post :create, { email: user.email, password: user.password }
    @controller = app_controller
    assert_equal user, @controller.send(:current_user)
  end

  test ":current_user should return nil if no user is logged in" do
    session[:user_id] = nil
    assert_nil @controller.send(:current_user)
  end
end

