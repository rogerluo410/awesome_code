module RequestLoginHelper
  def api_headers
    { 'HTTP_ACCEPT' => 'application/json' }
  end

  def token_headers(user, hash= {})
    token = user.auth_tokens.create!
    api_headers.merge('Authorization' => token.id).merge(hash)
  end

  def session_headers(user, hash= {})
    headers = {'X-Session-Auth' => true}
    headers.merge(hash)
  end
end
