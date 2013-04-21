require 'test_helper'
require 'json'

class ApiControllerTest < ActionController::TestCase
  setup do
    @controller = Api::V1::UsersController.new
  end

  test "show a certificate" do
    user = FactoryGirl.create(:user)
    get :show_certificate, 
      username: user.username, 
      certificate_id: user.certificates.first.id
    certificate = user.certificates.first
    json = JSON.parse(response.body)['certificate']
    puts certificate.created_at.class.name
    assert_equal certificate.nickname, json['nickname']
    assert_equal certificate.contents, json['contents']
    assert_equal certificate.fingerprint, json['fingerprint']
    assert_equal certificate.created_at.utc.iso8601, json['created_at']
    assert_equal certificate.updated_at.utc.iso8601, json['updated_at']
  end


  test "show a user" do
    user = FactoryGirl.create(:user)
    get :show, username: user.username
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

    user.certificates.each_with_index do |c, i|
      assert_not_nil json['certificates'][i]['certificate']['id']
      assert_not_nil json['certificates'][i]['certificate']['nickname']
      assert_not_nil json['certificates'][i]['certificate']['contents']
      assert_not_nil json['certificates'][i]['certificate']['fingerprint']
      assert_not_nil json['certificates'][i]['certificate']['created_at']
      assert_not_nil json['certificates'][i]['certificate']['updated_at']
    end
  end
end
