require 'test_helper'
require 'aws-sdk'
require 'zip'

#im not sure whether or not to use the Fake-S3 gem here...

class AdminIntegrationTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
  #	@admin = users(:michael)
#  	@image_1 = file_fixture('TestImage1.jpg')
# 	@image_2 = file_fixture('TestImage2.jpg')
  end


 test "Files uploaded from the file manager are correctly sent to S3" do
 #	assert_not_equal @image_1.size, ""

 end

 test "Files deleted through the file manager view are correctly removed from the S3 bucket" do


 end

 test "Files downloaded from S3 through the file manager are correctly sent to the client" do

 end



end
