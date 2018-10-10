[![Gem Version](https://badge.fury.io/rb/multi_session.svg)](https://badge.fury.io/rb/multi_session)
[![Build Status](https://travis-ci.org/seanhuber/multi_session.svg?branch=master)](https://travis-ci.org/seanhuber/multi_session)
[![Coverage Status](https://coveralls.io/repos/github/seanhuber/multi_session/badge.svg?branch=master)](https://coveralls.io/github/seanhuber/multi_session?branch=master)

multi_session
==============

`multi_session` is a Railtie that extends rails to provide the ability to have multiple sessions per user via encrypted cookies.

## Motivation

Rails comes with a `session` helper method for storing user session information across HTTP requests.  The default approach is to store that information in an encrypted cookie that gets passed as a header in each HTTP request/response.  That cookie is encrypted/decrypted using the `secret_key_base` defined in `config/secrets.yml` (or `config/credentials.yml.enc` as of Rails version 5.2).

Rails' `session` is secure and works great but what if you'd like to share that session cookie with multiple Rails applications hosted across different subdomains? Various blogs and stackoverflow questions on the matter suggest sharing the same `secret_key_base` value amongst the multiple Rails applications.  But what if these apps only want to share part of the session information? Or what if there are security concerns because `secret_key_base` is used for more than just encrypting session cookies? This `multi_session` railtie provides a helper method (named `multi_session`) similar to `session` except that it permits you to create multiple encrypted session cookies per user, each with their own secret key, giving you the flexibility to choose which session components could be shared with other Rails (and non-Rails) web applications.

## Usage

`multi_session` is a helper method that gets added to your `ApplicationController` and is therefore accessible by all your controllers that subclass `ApplicationController`, as well all view templates.  To create and read new sessions, use bracket notation (`[]` and `[]=`) like you would with `Hash` or hash-like objects.

For example:

```ruby
# app/controllers/some_controller.rb

class SomeController < ApplicationController
  def my_action
    @user = User.find(params.require(:id))
    multi_session[:global_user_session] = {
      'user_id' => @user.id,
      'email'   => @user.email,
      'name'    => @user.full_name
    }
    multi_session[:user_preferences] = {
      'enable_push_notifications' => true,
      'something_else' => false
    }
  end

  def another_action
    @user = User.find(multi_session[:global_user_session]['user_id'])
  end
end
```

In the example above, multi_session would create 2 encrypted cookies, one named `"global_user_session"` and the other named `"user_preferences"`.  The key_base used to encrypt/decrypt these cookies would need to be defined in `config/secrets.yml` or `config/credentials.yml.enc` under a key named `:multi_session_keys`.  Example:

```yaml
# config/credentials.yml.enc
secret_key_base: # generated by Rails

multi_session_keys: # use `rake secret` to generate custom keys
  global_user_session: # insert a new secret here
  user_preferences: # insert a different secret here
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'multi_session', '~> 1.1'
```

## Configuration

For the current version `multi_session`, there these are the configuration values that can optionally be set:

| Config option                         | Type                    | Description                                           |
|---------------------------------------|-------------------------|-------------------------------------------------------|
| `expires`                             | ActiveSupport::Duration | expiration  period for `multi_session` cookies/values |
| `authenticated_encrypted_cookie_salt` | String                  | Salt used to derive key for GCM encryption            |


To configure `multi_session`, first generate an initializer using the built-in rails generator:

```
rails g multi_session:install
```

Then open and edit `config/initializers/multi_session.rb`:

```ruby
# config/initializers/multi_session.rb

MultiSession.setup do |config|
  # Uncomment to force multi_session cookies to expire after a period of time
  config.expires = 30.minutes

  # Salt used to derive key for GCM encryption. Default value is 'multi session authenticated encrypted cookie'
  config.authenticated_encrypted_cookie_salt = 'my multi session salt value'
end
```

## Security

`multi_session` does not introduce any novel security mechanisms. Encryptions/decryption is done using `ActiveSupport::MessageEncryptor` in the same manner that Rails encrypts the `session` cookie in Rails 5.2 (see https://github.com/rails/rails/blob/5fb4703471ffb11dab9aa3855daeef9f592f6388/actionpack/lib/action_dispatch/middleware/cookies.rb).

The default cipher for encrypting messages in Rails 5.2 is `AES-256-GCM`, which is the same as what `multi_session` uses.

There are many good writeups on the web (such as https://guides.rubyonrails.org/security.html, https://www.justinweiss.com/articles/how-rails-sessions-work/, and https://www.theodinproject.com/courses/ruby-on-rails/lessons/sessions-cookies-and-authentication) that go into detail of how Rails addresses session security concerns and I encourage all app developers to spend some time educating themselves on how Rails sessions work.

The implementation of `multi_session` is actually quite simple because it leans heavily on existing Rails functionality. The nuts and bolts are primarily coded in `lib/multi_session/session.rb` (https://github.com/seanhuber/multi_session/blob/b0211d714d995dc01eb817e52f5dc78e52120bf0/lib/multi_session/session.rb).  It's a small file, please do your own code-audit before using this gem. :wink:

## Contributing

Pull requests and issue reports are welcome!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
