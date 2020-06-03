module MultiSession
  class Railtie < ::Rails::Railtie
    config.multi_session = ActiveSupport::OrderedOptions.new

    initializer 'multi_session.configure_rails_initialization' do |app|
      ActionController::Base.send :include, MultiSession::Helper

      ms_config = app.config.multi_session

      # Try to lookup multi_session_keys
      if ms_config.credentials_strategy.nil?
        if app.config.respond_to?(:creds) and app.config.creds.multi_session_keys.present?
          ms_config.credentials_strategy = :creds

        elsif app.secrets.has_key? :multi_session_keys
          ms_config.credentials_strategy = :secrets

        else
          ms_config.credentials_strategy = :credentials
        end
      end

      MultiSession.setup do |options|
        if ms_config.authenticated_encrypted_cookie_salt.present?
          options.authenticated_encrypted_cookie_salt = ms_config.authenticated_encrypted_cookie_salt
        end

        options.expires = ms_config.expires if ms_config.expires.present?
        options.domain = ms_config.domain if ms_config.domain.present?

        options.credentials_strategy = ms_config.credentials_strategy
      end
    end
  end
end
