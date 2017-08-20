ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'simplecov'
require 'codecov'

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
 SimpleCov::Formatter::HTMLFormatter,
 SimpleCov::Formatter::Codecov
])
SimpleCov.start 'rails'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user, options = {})
    password = options[:password] || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, session_hash(user, password, remember_me)
    else
      session[:user_id] = user.id
    end
  end

  private

  def integration_test?
    defined?(post_via_redirect)
  end

  def session_hash(user, password, remember_me)
    { session: { email: user.email,
                 password: password,
                 remember_me: remember_me } }
  end
end
