require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  setup do
  end

  def perform_action_with(controller = nil, &block)
    app_controller = @controller
    @controller = controller.new
    block.call
    @controller = app_controller
  end

  test ":current_user should return the logged-in user" do
    user = FactoryGirl.create(:user)
    perform_action_with(SessionsController) do
      post :create, { email: user.email, password: user.password }
    end
    assert_equal user, @controller.send(:current_user)
  end

  test ":current_user should return nil if no user is logged in" do
    session[:user_id] = nil
    assert_nil @controller.send(:current_user)
  end

  test "should redirect to the login URL on access denied" do
    user = FactoryGirl.create(:user)
    session[:user_id] = nil
    perform_action_with(UsersController) do
      get :show, id: user.id
    end
    assert_redirected_to login_path
  end
end

