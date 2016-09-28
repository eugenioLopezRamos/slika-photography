require 'test_helper'
require 'aws-sdk'
require 'zip'
require 'find'

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

# I will integrate all three tests(put object/get object/delete object) in this same tests, otherwise
# I'd need to duplicate the uploading of the fixture files, which is slow (and costs money)

# Find "#START TEST => UPLOADS" (WITHOUT the quotation marks) to go to the beginning of the uploads test
# Find "#START TEST => DOWNLOADS" (WITHOUT the quotation marks) to go to the beginning of the downloads test
# Find "#START TEST => DOWNLOADS_INFO" (WITHOUT the quotation marks) to go to the beginning of the req_download_info test
# Find "#START TEST => DELETIONS" (WITHOUT the quotation marks) to go to the beginning of the file delete test
 test "Files uploaded from the file manager are correctly sent to S3" do
 	#log in.
 	log_in_as(@admin)
 	get admin_files_path
 	#create a S3 client instance to use with tests.
	s3 = Aws::S3::Client.new

 	#START TEST => UPLOADS
	 	#POST request with no images, should render the "No files" message in admin/flash_messages and return
	 	post admin_upload_path(@admin), params: {file_route: '', image: []}
	 	assert_response :success
	 	assert_select 'div.alert'

	 	#POST files from the view - The most important part is an array of files under param image
	 	file_route = ''
	 	uploaded_images_array = [@uploaded_image_1, @uploaded_image_2]
	  	post admin_upload_path(@admin), params: {file_route: file_route, image: uploaded_images_array}
	  	#maybe add a second upload with an actual file_route instead of just empty and refactor the loop code
	  	#to loop over arrays and them over images.


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
	  	end

  	#START TEST => DOWNLOADS

  		#POST from the view, requesting the files to download.
  		files_array = "[\"TestImage1.jpg\", \"TestImage2.jpg\"]"
  		mock_auth_token = "12345/678"
  		mock_auth_token_to_file = mock_auth_token.gsub(/(\/+)*/, '')

  		original_directory_file_count = Dir["#{Rails.root}/tmp/*"].length


  		#assert_difference 'original_directory_file_count', (JSON.parse(files_array).length + 1) do #That is, length of files_array (each downloaded file,
  																			   #plus the download_log)
  																			   #this one goes at the end of the test
	#assert_difference 'original_directory_file_count', (files_array.length + 2) do  # amount of downloaded files (files_array.length)
																					# + zipfile  
																					# + download_log = files_array.length +2

		  	post admin_download_file_path(@admin), params: {'authenticity-token': mock_auth_token, files: files_array}
		  	files_array = JSON.parse(files_array) #Need to parse it to compare, otherwise I'd need to JSON.parse every time I need to compare...

	  		#GET_OBJECT is done by the controller. Our job is to check that the controller actions are having no errors.

		  	files_array.each do |file|
		  	
		  		#Test if download_log exists
		  		assert File.file?("#{Rails.root}/tmp/download_log-#{mock_auth_token_to_file}.txt")
		  		zip_file_location = ""
		  			
		  		#Need to flush all zipfiles from the temp folder before testing - Otherwise I'll get errors when using Find.find
		  		Find.find("#{Rails.root}/tmp") do |path|

			  		if File.basename(path) =~ /temp\.zip(\-*\w*\-*)*/

			  			zip_file_location = "#{Rails.root}/tmp/#{File.path(File.basename(path))}" #This looks very very ugly, needs a bit of prettifying
			  			puts "zip file loc: #{zip_file_location}"
						Find.prune       # Don't look any further into this directory.
					else
						next
					end
		
				end

				zip_file_contents = []
			
		  		Zip::File.open(zip_file_location) do |zip_file|

		  			zip_file.each do |zip_entry|

		  				uploaded_images_array.each do |file| #This block compares the original size of the file in the zip archive to its 
		  													#corresponding fixture uploaded tempfile.

		  					if file.original_filename === zip_entry.name
		  						assert_equal zip_entry.size, file.size
		  					end

		  				end


		  				zip_file_contents.push zip_entry.name
		  			end

		  		end

		  		assert_equal zip_file_contents, files_array
		  
		 	
		  	end
		  	
		  	#Test that the files still exist.
		  	assert_equal (original_directory_file_count + files_array.length + 2), Dir["#{Rails.root}/tmp/*"].length	

	  	


	#START TEST => DOWNLOADS_INFO


  	#CLEANUP - delete the downloaded files after success



    #START TEST => DELETIONS
    	#DELETE request from the view, detailing files to delete.

        #delete the test objects - Need to adapt it to be delete_objects with an array as objects
      #  s3.delete_object(bucket: ENV['AWS_S3_BUCKET'], key: "#{image_file_route}#{image_file_name}")

     #   should_be_empty = s3.list_objects(bucket: ENV['AWS_S3_BUCKET'], marker: '#{image_file_route}').contents ## key: "#{image_file_route}#{image_file_name}").contents
    #    should_be_empty = should_be_empty.select{|entry| entry.key === "#{image_file_route}#{image_file_name}"}.map(&:key)

     #   #Unexistant file key returns [] (empty array) - Therefore should_be_empty should be equal to empty array.
     #   assert should_be_empty.empty?




 end



 test "Files deleted through the file manager view are correctly removed from the S3 bucket" do





 end




 test "Files downloaded from S3 through the file manager are correctly sent to the client" do




 end



end
