ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!


Aws.config[:stub_responses] = true
#sets up test img stubs
img_1_sizes = [{key:"/images/post-test/original-testImage1.jpg"}, 
               {key: "/images/post-test/1500-testImage1.jpg"},
               {key:"/images/post-test/1100-testImage1.jpg"}, 
               {key:"/images/post-test/900-testImage1.jpg"},
               {key:"/images/post-test/700-testImage1.jpg"}, 
               {key:"/images/post-test/480-testImage1.jpg"}, 
               {key:"/images/post-test/100-testImage1.jpg"},


               {key:"original-testImage1.jpg", size: 534096}, 
               {key: "1500-testImage1.jpg"},
               {key:"1100-testImage1.jpg"}, 
               {key:"900-testImage1.jpg"}, 
               {key:"700-testImage1.jpg"}, 
               {key:"480-testImage1.jpg"}, 
               {key:"100-testImage1.jpg"},
                 
               {key:"another/route/here/original-testImage1.jpg", size: 534096}, 
               {key: "another/route/here/1500-testImage1.jpg"},
               {key:"another/route/here/1100-testImage1.jpg"}, 
               {key:"another/route/here/900-testImage1.jpg"}, 
               {key:"another/route/here/700-testImage1.jpg"}, 
               {key:"another/route/here/480-testImage1.jpg"}, 
               {key:"another/route/here/100-testImage1.jpg"}   
              ]

img_2_sizes = [{key: "/images/post-test/original-testImage2.jpg"}, 
               {key:"/images/post-test/1500-testImage2.jpg"},
               {key: "/images/post-test/1100-testImage2.jpg"}, 
               {key:"/images/post-test/900-testImage2.jpg"},
               {key:"/images/post-test/700-testImage2.jpg"}, 
               {key: "/images/post-test/480-testImage2.jpg"}, 
               {key:"/images/post-test/100-testImage2.jpg"},
              
               {key:"original-testImage2.jpg", size: 536450}, 
               {key: "1500-testImage2.jpg"},
               {key:"1100-testImage2.jpg"}, 
               {key:"900-testImage2.jpg"}, 
               {key:"700-testImage2.jpg"}, 
               {key:"480-testImage2.jpg"}, 
               {key:"100-testImage2.jpg"},
                         
               {key:"another/route/here/original-testImage2.jpg", size: 536450}, 
               {key: "another/route/here/1500-testImage2.jpg"},
               {key:"another/route/here/1100-testImage2.jpg"}, 
               {key:"another/route/here/900-testImage2.jpg"}, 
               {key:"another/route/here/700-testImage2.jpg"}, 
               {key:"another/route/here/480-testImage2.jpg"}, 
               {key:"another/route/here/100-testImage2.jpg"}            
]
mock_objects = img_1_sizes + img_2_sizes
get_object_stub_1 = File.open("#{Rails.root}/test/fixtures/files/testImage1.jpg", "r")

get_object_stub_2 = File.open("#{Rails.root}/test/fixtures/files/testImage2.jpg", "r")

s3 = Aws::S3::Client.new(stub_responses: true)

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
