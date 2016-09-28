require 'test_helper'
require 'aws-sdk'
require 'zip'

#im not sure whether or not to use the Fake-S3 gem here...
# also check out VCR for recording requests

class AdminIntegrationTest < ActionDispatch::IntegrationTest

  def setup
  	@admin = users(:michael)
  	@image_1 = file_fixture('TestImage1.jpg')
 	@image_2 = file_fixture('TestImage2.jpg')
 	@uploaded_image_1 = Rack::Test::UploadedFile.new(@image_1, "image/jpeg")
	@uploaded_image_2 = Rack::Test::UploadedFile.new(@image_2, "image/jpeg")

	#AWS setup is done controller side. It could be useful to have a "test" bucket though, just for tests.

  end

#im not sure if these are 100% ok, since all of these are done via AJAX requests instead of through rails "standard" forms

 test "Files uploaded from the file manager are correctly sent to S3" do
 	log_in_as(@admin)
 	#POST request with no images, should render the "No files" message in admin/flash_messages and return
 	post admin_upload_path(@admin), params: {file_route: '', image: []}
 	assert_response :success
 	assert_select 'div.alert'

 	#POST files from the view - The most important part is an array of files under param image
 	file_route = ''
 	uploaded_images_array = [@uploaded_image_1, @uploaded_image_2]
  	post admin_upload_path(@admin), params: {file_route: file_route, image: uploaded_images_array}

  	#create a S3 client instance to use with tests.
  	s3 = Aws::S3::Client.new


  	uploaded_images_array.each do |image|

  		#same local variables as the controller
        image_file = image.tempfile 
        image_file_name = image.original_filename
        image_file_route = file_route 
        #plus the tempfile size
        image_file_size = image.tempfile.size

  		#tests route + original filename being equal to the route + filename on the bucket(eg. is file uploaded to the intended "folder"?).
  		test_uploaded_file_listing = s3.list_objects(bucket: ENV['AWS_S3_BUCKET'], marker: image_file_route).contents
        test_uploaded_file_listing = test_uploaded_file_listing.select{ |entry| entry.key === "#{image_file_route}#{image_file_name}"  }.map(&:key)

        #Test filenames being the same - image_file_name is in an array because the result from S3 is also an array (in this case, of one item.)
        assert_equal [image_file_name], test_uploaded_file_listing

        #Should give back only one item.
        assert_equal test_uploaded_file_listing.length, 1
        #Test route on the bucket being same to params[:file_route] + image_file_name.      
        assert_equal "#{image_file_route}#{image_file_name}", "#{image_file_route}#{test_uploaded_file_listing[0]}"

        #tests same file size - I'm doing this comparison instead of downloading the file with get_object then comparing them.
        test_uploaded_file_size = s3.list_objects(bucket: ENV['AWS_S3_BUCKET'], marker: image_file_route).contents
        test_uploaded_file_size = test_uploaded_file_size.select{ |entry| entry.key === "#{image_file_route}#{image_file_name}"  }.map(&:size)
        assert_equal image.size, test_uploaded_file_size[0]

        #delete the test object - doesnt need to assert anything, that will be done in the delete test in this same test file.

        s3.delete_object(bucket: ENV['AWS_S3_BUCKET'], key: "#{image_file_route}#{image_file_name}")

        should_be_empty = s3.list_objects(bucket: ENV['AWS_S3_BUCKET'], marker: '#{image_file_route}').contents ## key: "#{image_file_route}#{image_file_name}").contents
        should_be_empty = should_be_empty.select{|entry| entry.key === "#{image_file_route}#{image_file_name}"}.map(&:key)

        #Unexistant file key returns [] (empty array) - Therefore should_be_empty should be equal to empty array.
        assert should_be_empty.empty?

  	end



 	#Parameters: {"utf-8"=>"✓", "authenticity-token"=>"9ntEHqW6Scr2lU6v8MHZSq74EFkOOLpY+pIaMBihpScOQclbNZjaH+Wv7tV1Gt1bEiOJzhlmBsezleO8qYdJRQ==", "file_route"=>"", 
 	#{}"image"=>[#<ActionDispatch::Http::UploadedFile:0x007f1f30288128 @tempfile=#<Tempfile:/tmp/RackMultipart20160928-28595-t8yii8.jpg>, @original_filename="10.jpg", @content_type="image/jpeg", @headers="Content-Disposition: form-data; name=\"image[]\"; filename=\"10.jpg\"\r\nContent-Type: image/jpeg\r\n">, 
 	#<ActionDispatch::Http::UploadedFile:0x007f1f30288100 @tempfile=#<Tempfile:/tmp/RackMultipart20160928-28595-1cz39mh.jpg>, @original_filename="camera-background.jpg", @content_type="image/jpeg", @headers="Content-Disposition: form-data; name=\"image[]\"; filename=\"camera-background.jpg\"\r\nContent-Type: image/jpeg\r\n">, 
 	#<ActionDispatch::Http::UploadedFile:0x007f1f302880d8 @tempfile=#<Tempfile:/tmp/RackMultipart20160928-28595-1st5t7d.jpg>, @original_filename="camera-background nuevo.jpg", @content_type="image/jpeg", @headers="Content-Disposition: form-data; name=\"image[]\"; filename=\"camera-background nuevo.jpg\"\r\nContent-Type: image/jpeg\r\n">]}



 #	assert_not_equal @image_1.size, ""

 end



 test "Files deleted through the file manager view are correctly removed from the S3 bucket" do





 end




 test "Files downloaded from S3 through the file manager are correctly sent to the client" do




 end



end
