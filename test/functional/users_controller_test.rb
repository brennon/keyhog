require 'test_helper'
require 'json'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user ||= FactoryGirl.create(:user)
    session[:user_id] = @user.id
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
      user = FactoryGirl.build(:user)
      post :create, user: {
        username: user.username,
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        password: user.password,
        password_confirmation: user.password_confirmation
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

  test "should redisplay the edit form if user does not save" do
    put :update, id: @user, user: { 
      email: @user.email, 
      username: nil,
      password: @user.password,
      password_confirmation: @user.password_confirmation
    }
    assert_template 'edit'
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    put :update, id: @user, user: { 
      email: @user.email, 
      username: @user.username,
      password: @user.password,
      password_confirmation: @user.password_confirmation
    }
    assert_redirected_to user_path(assigns(:user))
  end

  test "should render a new pair form" do
    get :new_pair, id: @user
    assert_response :success
  end

  test "should assign the user in new pair form" do
    get :new_pair, id: @user
    assert_equal @user, assigns(:user)
  end

  test "should validate new pair form" do
    UsersController.any_instance.expects(:validate_pair_parameters)
    post :create_pair, id: @user
  end

  test "pair creation sends pair" do
    post :create_pair, id: @user, certificate_pair: {
      type: 'RSA',
      length: '2048',
      comment: 'comment'
    }
    # assert_equal 'id_rsa.prv', response[:filename]
  end

  test "pair requires a comment" do
    post :create_pair, id: @user, certificate_pair: { comment: nil }
    assert flash[:warn] =~ /A comment is required/
  end

  test "passphrase must be at least four characters" do
    post :create_pair, id: @user, certificate_pair: { passphrase: '123' }
    assert flash[:warn] =~ /Passphrase must be at least four characters long/
  end

  test "pair requires a type" do
    post :create_pair, id: @user, certificate_pair: {
      comment: 'comment',
      type: nil
    }
    assert flash[:warn] =~ /A type is required/
  end

  test "pair requires a length" do
    post :create_pair, id: @user, certificate_pair: {
      type: 'RSA',
      comment: 'comment',
      length: nil
    }
    assert flash[:warn] =~ /A length is required/
  end

  test "DSA pairs can only be 1024-bits" do
    post :create_pair, id: @user, certificate_pair: {
      type: 'DSA',
      comment: 'comment',
      length: '2048'
    }
    assert flash[:warn] =~ /DSA pairs can only be 1024 bits long/
  end

  test "passphrase must be confirmed" do
    post :create_pair, id: @user, certificate_pair: {
      type: 'DSA',
      comment: 'comment',
      length: '1024',
      passphrase: 'passphrase',
      passphrase_confirmation: 'pasphrase'
    }
    assert flash[:warn] =~ /Passphrase and passphrase confirmation must match/
  end

  test "passphrase is required" do
    post :create_pair, id: @user, certificate_pair: {
      type: 'DSA',
      comment: 'comment',
      length: '1024',
      passphrase: '',
      passphrase_confirmation: ''
    }
    assert flash[:warn] =~ /A passphrase is required/
  end
end
