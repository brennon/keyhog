require 'test_helper'

class CertificatesControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @certificate = FactoryGirl.build(:certificate)
  end

  test "should get index" do
    get :index, user_id: @user.id
    assert_response :success
    assert_not_nil assigns(:certificates)
  end

  test "should get new" do
    get :new, user_id: @user.id
    assert_response :success
  end
  
  test "should create certificate" do
    fresh_cert = FactoryGirl.build(:certificate, user: nil)
    puts fresh_cert.user_id
    assert_difference('Certificate.count') do
      post :create, certificate: { contents: @certificate.contents, fingerprint: @certificate.fingerprint, nickname: @certificate.nickname }, user_id: @user.id
    end

    assert_redirected_to user_certificate_path(@user, assigns(:certificate))
  end

  test "should show certificate" do
    session[:user_id] = @user.id
    certificate = FactoryGirl.create(:certificate, user_id: @user.id)
    get :show, id: certificate, user_id: @user.id
    assert_response :success
  end

  test "should get edit" do
    session[:user_id] = @user.id
    certificate = FactoryGirl.create(:certificate, user_id: @user.id)
    get :edit, id: certificate, user_id: @user.id
    assert_response :success
  end

  test "should update certificate" do
    session[:user_id] = @user.id
    certificate = FactoryGirl.create(:certificate, user_id: @user.id)
    put :update, id: certificate, certificate: { contents: certificate.contents, fingerprint: certificate.fingerprint, nickname: certificate.nickname, user_id: certificate.user_id }, user_id: @user.id
    assert_redirected_to user_certificate_path(@user, assigns(:certificate))
  end

  test "should destroy certificate" do
    session[:user_id] = @user.id
    certificate = FactoryGirl.create(:certificate, user_id: @user.id)

    assert_difference('Certificate.count', -1) do
      delete :destroy, id: certificate, user_id: @user.id
    end

    assert_redirected_to user_certificates_path(@user)
  end
end
