require 'test_helper'

class ContactMailerControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
  	ActionMailer::Base.deliveries.clear
  end


  test "The controller correctly sends the email" do

  	post '/contact', params: {clientName: "Perico", 
  							  clientEmail: "aaaa@gmail.com", 
  							  clientSubject: "Hi I'm contacting you", 
  							  clientMessage: "this is a message" }

  	assert_equal 1, ActionMailer::Base.deliveries.size

  end

end

