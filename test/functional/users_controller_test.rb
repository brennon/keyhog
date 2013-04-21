require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.build(:user)
  end

  test "should get index" do
    get :index
    assert_redirected_to root_url
    # assert_response :success
    # assert_not_nil assigns(:users)
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

  test "should destroy user" do
    @user.save
    session[:user_id] = @user.id

    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_path
  end
end
