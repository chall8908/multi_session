MultiSession.setup do |config|
  # Uncomment to force multi_session cookies to expire after a period of time
  # config.expires = 30.minutes

  # Salt used to derive key for GCM encryption. Default value is 'multi session authenticated encrypted cookie'
  # config.authenticated_encrypted_cookie_salt = 'multi session authenticated encrypted cookie'
end
