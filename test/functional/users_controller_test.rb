require 'test_helper'
require 'json'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.build(:user)
  end

  test "should get index" do
    get :index
    assert_redirected_to root_url
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {
        username: @user.username,
        email: @user.email,
        first_name: @user.first_name,
        last_name: @user.last_name,
        password: @user.password,
        password_confirmation: @user.password_confirmation
      }
    end
    assert_redirected_to user_path(assigns(:user))
  end

  test "should redisplay the new form if user does not save" do
    post :create, user: {
      username: nil,
      email: @user.email,
      first_name: @user.first_name,
      last_name: @user.last_name,
      password: @user.password,
      password_confirmation: @user.password_confirmation
    }
    assert_template 'new'
  end


  test "should show user" do
    @user.save
    session[:user_id] = @user.id

    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    @user.save
    session[:user_id] = @user.id

    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    @user.save
    session[:user_id] = @user.id

    put :update, id: @user, user: { 
      email: @user.email, 
      username: @user.username,
      password: @user.password,
      password_confirmation: @user.password_confirmation
    }
    assert_redirected_to user_path(assigns(:user))
  end
end
