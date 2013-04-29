require 'oauth2'

# 1. Logout current user
# 2. Login another user
# 3. Click Authorize link
# 4. Copy code
# 8. get_api_urls(code)


@callback = "urn:ietf:wg:oauth:2.0:oob"
@app_id = "a1beccd7094c3530811bdb4626518bb2e6c1150e3edc4b69ee3f9e62873b625a"
@secret = "a41c626d46e527ad1ba736b22f32fff7482066d055ced8ccec8043e65c2c87a4"

puts "Instructions:"
puts "Set @callback, @app_id, @secret, and @keyhog_url directly"
puts "Set @client with get_client"

def get_client
  @client = OAuth2::Client.new(@app_id, @secret, site: @keyhog_url)
end

def get_authorize_url
  "Authorize URL: #{@client.auth_code.authorize_url(redirect_uri: @callback)}"
end

def get_user_url(code)
  @access ||= @client.auth_code.get_token(code, redirect_uri: @callback)
  puts "Show User: #{@keyhog_url}/api/v1/user?access_token=#{@access.token}"
end
