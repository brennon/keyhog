require 'oauth2'

# 1. Logout current user
# 2. Login another user
# 3. Open irb
# 4. load('oauth_test.rb')
# 5. get_authorize_url
# 6. Browse to URL
# 7. Copy code
# 8. get_api_urls(code)


@callback = "urn:ietf:wg:oauth:2.0:oob"
@app_id = "a1beccd7094c3530811bdb4626518bb2e6c1150e3edc4b69ee3f9e62873b625a"
@secret = "a41c626d46e527ad1ba736b22f32fff7482066d055ced8ccec8043e65c2c87a4"
@client = OAuth2::Client.new(@app_id, @secret, site: "http://www.keyhog.com")

def get_authorize_url
	"Authorize URL: #{@client.auth_code.authorize_url(redirect_uri: @callback)}"
end

def get_api_urls(code)
  @access ||= @client.auth_code.get_token(code, redirect_uri: @callback)
  puts "Show User: http://www.keyhog.com/api/v1/user?access_token=#{@access.token}"
  puts "Show a Certificate: http://www.keyhog.com/api/v1/user/certificates/3?access_token=#{@access.token}"
  puts "Enable a Site for a Certificate: http://www.keyhog.com/api/v1/user/certificates/3/enable_site?access_token=#{@access.token}"
  puts "Deactivate a Certificate: http://www.keyhog.com/api/v1/user/certificates/3/deactivate?access_token=#{@access.token}"
  puts "Check a Certificate's Fingerprint: http://www.keyhog.com/api/v1/user/certificates/3/check_fingerprint?access_token=#{@access.token}"
end