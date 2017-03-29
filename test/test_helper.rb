ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
require 'mock_objects'
Minitest::Reporters.use!
include MockObjects
require 'application_helper'
include ApplicationHelper



if ApplicationHelper::env_keys_missing?
  Aws.config[:stub_responses] = true
  s3 = Aws::S3::Client.new(stub_responses: true)

  mock_objects = MockObjects::img_1_sizes + MockObjects::img_2_sizes
  get_object_stub_1 = File.open("#{Rails.root}/test/fixtures/files/testImage1.jpg", "r")

  get_object_stub_2 = File.open("#{Rails.root}/test/fixtures/files/testImage2.jpg", "r")
Aws.config[:s3] = {
  stub_responses: {
    list_objects: {contents: mock_objects},
  get_object: [
    {body: File.open("#{Rails.root}/test/fixtures/files/testImage1.jpg", "rb")},
    {body: File.open("#{Rails.root}/test/fixtures/files/testImage2.jpg", "rb")},
    {body: "1"}
  ]

  }
}
end





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
