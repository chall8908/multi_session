require 'multi_session/helper'
require 'multi_session/railtie'
require 'multi_session/session'

module MultiSession
  mattr_accessor :authenticated_encrypted_cookie_salt
  @@authenticated_encrypted_cookie_salt = 'multi session authenticated encrypted cookie'

  mattr_accessor :expires
  @@expires = nil

  mattr_accessor :domain
  @@domain = nil

  mattr_accessor :credentials_strategy
  @@credentials_strategy = nil

  def self.setup
    yield self
  end

  class Error < StandardError
  end

  class NoSessionKeys < Error
    def initialize
      super "Unable to find multi_session_keys." \
        "Check your configuration and ensure that `multi_session_keys' is present."
    end
  end

  class MissingSessionKey < Error
    def initialize(key)
      super "No multi_session_keys entry found for #{key.inspect}"
    end
  end
end
