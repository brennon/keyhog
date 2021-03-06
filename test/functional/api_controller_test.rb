require 'test_helper'
require 'json'

class ApiControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @controller = Api::V1::UsersController.new
    @token = Object.new
    @token.stubs(:accessible?).returns(true)
    @token.stubs(:resource_owner_id).returns(@user.id)
    @controller.stubs(:doorkeeper_token).returns(@token)
  end

  test "check a certificate fingerprint with a good fingerprint" do
    certificate = @user.certificates.first
    get :check_fingerprint, certificate_id: certificate.id, fingerprint: certificate.fingerprint
    json = JSON.parse(response.body)
    assert_equal 'valid fingerprint', json['result']
  end

  test "check a certificate fingerprint with a bad fingerprint" do
    certificate = @user.certificates.first
    get :check_fingerprint, certificate_id: certificate.id, fingerprint: 'INVALID'
    json = JSON.parse(response.body)
    assert_equal 'invalid fingerprint', json['result']
  end

  test "deactivate a certificate" do
    certificate = @user.certificates.first
    certificate.active = true
    certificate.save
    put :deactivate_certificate, certificate_id: certificate.id
    certificate.reload
    assert !certificate.active
    json = JSON.parse(response.body)['certificate']
    assert !json['active']
  end

  test "activate a certificate" do
    certificate = @user.certificates.first
    certificate.active = false
    certificate.save
    put :activate_certificate, certificate_id: certificate.id
    certificate.reload
    assert certificate.active
    json = JSON.parse(response.body)['certificate']
    assert json['active']
  end

  test "enable a site on a certificate" do
    certificate = @user.certificates.first
    external_site = FactoryGirl.create(:external_site)
    @token.stubs(:application).returns(stub(name: external_site.name))
    put :enable_site, certificate_id: certificate.id
    certificate.reload
    assert_equal external_site, certificate.external_sites.first
    json = JSON.parse(response.body)['certificate']['external_sites'][0]['external_site']
    assert_equal external_site.name, json['name']
  end

  test "can't enable a certificate for another user" do
    certificate = FactoryGirl.create(:certificate)
    external_site = FactoryGirl.create(:external_site)
    @token.stubs(:application).returns(stub(name: external_site.name))
    put :enable_site, certificate_id: certificate.id
    assert_response 401
  end

  test "enable a brand new site on a certificate" do
    certificate = @user.certificates.first
    @token.stubs(:application).returns(stub(name: 'GitGitGit'))
    put :enable_site, certificate_id: certificate.id
    json = JSON.parse(response.body)['certificate']['external_sites'][0]['external_site']
    assert_equal 'GitGitGit', json['name']
  end

  test "show a certificate" do
    certificate = @user.certificates.first
    get :show_certificate,
      certificate_id: certificate.id
    json = JSON.parse(response.body)['certificate']
    assert_equal certificate.nickname, json['nickname']
    assert_equal certificate.contents, json['contents']
    assert_equal certificate.fingerprint, json['fingerprint']
    assert_equal certificate.created_at.utc.iso8601, json['created_at']
    assert_equal certificate.updated_at.utc.iso8601, json['updated_at']
  end

  test "can't show a certificate for another user" do
    certificate = FactoryGirl.create(:certificate)
    get :show_certificate,
      certificate_id: certificate.id
    assert_response 401
  end

  test "show a user" do
    get :show, id: @user.id
    json = JSON.parse(response.body)['user']
    assert_not_nil json['username']
    assert_not_nil json['first_name']
    assert_not_nil json['last_name']
    assert_not_nil json['certificates']
    assert_not_nil json['email']
    assert_nil json['hashed_password']
    assert_nil json['salt']
    assert_nil json['created_at']
    assert_nil json['updated_at']

    @user.certificates.each_with_index do |c, i|
      assert_not_nil json['certificates'][i]['certificate']['id']
      assert_not_nil json['certificates'][i]['certificate']['nickname']
      assert_not_nil json['certificates'][i]['certificate']['contents']
      assert_not_nil json['certificates'][i]['certificate']['fingerprint']
      assert_not_nil json['certificates'][i]['certificate']['created_at']
      assert_not_nil json['certificates'][i]['certificate']['updated_at']
    end
  end
end
