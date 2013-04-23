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
@app_id = "b3bf7e5505da7de34e893d5ec1016f9c628eaf9d868e6f1d72560bc1ea85087e"
@secret = "30e22c98d02e04650e040b639839e9dfa21e2e70c313428d9aff513a6d1f8e05"
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