ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  def is_logged_in?
    !session[:admin_user_id].nil?
  end
  #log in as a particular user
  def log_in_as(user)
    session[:admin_user_id] = user.id
  end
end
  # Add more helper methods to be used by all tests here...
  include ApplicationHelper
  
class ActionDispatch::IntegrationTest

  #log in as a particular user
  def log_in_as(user, password: 'password', remember_me: '1')

    post admin_login_path, params: { session: { email: user.email,
                                               password: password,
                                               remember_me: remember_me
                                            
                                               } }


  end
  
end
