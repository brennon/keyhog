require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create session" do
    user = FactoryGirl.create(:user)
    post :create, { email: user.email, password: user.password }
    assert_equal user.id, session[:user_id]
  end

  test "valid login should redirect to the root path" do
    user = FactoryGirl.create(:user)
    post :create, { email: user.email, password: user.password }
    assert_redirected_to root_path
  end

  test "valid login shows 'Logged in!' notice" do
    user = FactoryGirl.create(:user)
    post :create, { email: user.email, password: user.password }
    assert_equal 'Logged in!', flash[:notice]
  end

  test "invalid login should re-render the login page" do
    user = FactoryGirl.create(:user)
    post :create, { email: user.email, password: "INVALID" }
    assert_template 'new'
  end

  test "invalid login shows bad credentials flash" do
    user = FactoryGirl.create(:user)
    post :create, { email: user.email, password: "INVALID" }
    assert_equal 'Email or password is invalid', flash.now[:notice]
  end

  test "should clear session[:user_id] on destroy" do
    session[:user_id] = 99
    delete :destroy, id: 99 
    assert_nil session[:user_id]
  end
end
