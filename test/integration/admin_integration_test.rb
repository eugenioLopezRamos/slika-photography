require 'test_helper'
require 'aws-sdk'
require 'zip'
require 'find'

#im not sure whether or not to use the Fake-S3 gem here...
# also check out VCR for recording requests

class AdminIntegrationTest < ActionDispatch::IntegrationTest

  def setup
  	@admin = users(:michael)
  	@image_1_name = 'testImage1.jpg'
  	@image_2_name = 'testImage2.jpg'

  	@image_1 = file_fixture('testImage1.jpg')
 	@image_2 = file_fixture('testImage2.jpg')

 	@heavy_img = file_fixture('heavy-img.jpg')

 	@uploaded_image_1 = Rack::Test::UploadedFile.new(@image_1, "image/jpeg")
	@uploaded_image_2 = Rack::Test::UploadedFile.new(@image_2, "image/jpeg")

	@uploaded_heavy_img = Rack::Test::UploadedFile.new(@heavy_img, "image/jpeg")

	#Skips the tests if any of these ENV variables is nil, since they are required to correctly test the controller.
	
	# if ENV['AWS_S3_BUCKET'].nil? || ENV['AWS_SECRET_ACCESS_KEY'].nil? || ENV['AWS_REGION'].nil? || ENV['AWS_ACCESS_KEY_ID'].nil?
	# 	skip "At least one of these ENV variables is nil:\n  
	# 	ENV['AWS_S3_BUCKET'], \n
	# 	ENV['AWS_SECRET_ACCESS_KEY'], \n
	# 	ENV['AWS_REGION']\n
	# 	ENV['AWS_ACCESS_KEY_ID'],\n 
	# 	Can't test S3 integration -> skipping AdminIntegrationTest"
		
	# end



  end

#im not sure if these are 100% ok, since all of these are done via AJAX requests instead of through rails "standard" forms

# I will integrate all three tests(put object/get object/delete object) in this same test, otherwise
# I'd need to duplicate the uploading of the fixture files, which is slow (and costs money)

# Find "#START TEST => UPLOADS" (WITHOUT the quotation marks) to go to the beginning of the uploads test
# Find "#START TEST => DOWNLOADS" (WITHOUT the quotation marks) to go to the beginning of the downloads test
# Find "#START TEST => DOWNLOADS_INFO" (WITHOUT the quotation marks) to go to the beginning of the req_download_info test
# Find "#START TEST => DELETIONS" (WITHOUT the quotation marks) to go to the beginning of the file delete test

 test "Tests full file manager flow -> Uploads files from disk to S3, downloads them from S3 to disk while generating logs, then deletes them" do
 		#maybe add a second upload with an actual file_route instead of just empty and refactor the loop code
	  	#to loop over arrays and them over images? sounds slow but is more thorough.

 	#log in.
 	log_in_as(@admin)
 	get admin_files_path
	uploaded_images_array = [@uploaded_image_1, @uploaded_image_2]

 	#create a S3 client instance to use with tests.
	s3 = Aws::S3::Client.new

	 	file_routes_array = ['', 'another/route/here/'] #tests the root and a nested directory

 	#START TEST => UPLOADS
	 	#POST request with no images, should render the "No files" message in admin/flash_messages and return
	 	post admin_upload_path(@admin), params: {file_route: '', image: []}
	 	assert_response :success
	 	assert_select 'div.alert'

	 	#POST with too much data (in MBs)
	 	assert_no_difference 'Dir["#{Rails.root}/tmp/*"].length' do
		 post admin_upload_path(@admin), params: {file_route: '', image: [@uploaded_heavy_img]}
		 assert_select 'div.alert'
		end
		
	file_routes_array.each do |file_route|

	#POST files from the view - The most important part is an array of files under param image

	  	post admin_upload_path(@admin), params: {file_route: file_route, image: uploaded_images_array}

	  	uploaded_images_array.each do |image|

	        image_file_name = "#{image.original_filename}"
	        image_file_route = file_route 

	  		#tests route + prefix + original filename being equal to the route + filename on the bucket(eg. is file uploaded to the intended "folder"?).
	  		@test_uploaded_file_listing = s3.list_objects(bucket: ENV['AWS_S3_BUCKET'], marker: image_file_route).contents
			
			#get all corresponding sizes
			sizes = @controller.calc_sizes(size_breakpoints, image)
			sizes.unshift("original") #adds a new item at the beginning of the array, "original" which is the unmodified version of the img

			#this tests the existence of each version of the img
			sizes.each do |prefix|
		
				block_uploaded_file_listing = @test_uploaded_file_listing.select{ |entry| entry.key === "#{image_file_route}#{prefix}-#{image_file_name}"  }.map(&:key)

				#Test filenames being the same - image_file_name is in an array because the result from S3 is also an array (in this case, of one item.)
		
				assert_equal ["#{file_route}#{prefix}-#{image_file_name}"], block_uploaded_file_listing
				#Should give back only one item.
				assert_equal block_uploaded_file_listing.length, 1
				#Test route on the bucket being same to params[:file_route] + image_file_name.      
				assert_equal "#{image_file_route}#{prefix}-#{image_file_name}", "#{block_uploaded_file_listing[0]}"

			end

			#tests same original file size - I'm doing this comparison instead of downloading the file with get_object then comparing them.
			test_uploaded_file_size = @test_uploaded_file_listing.select {|entry| entry.key === "#{image_file_route}original-#{image_file_name}"}.map(&:size)
			
			assert_equal image.size, test_uploaded_file_size[0]

	  	end

  	#START TEST => DOWNLOADS

  		files_array = ["#{file_route}original-testImage1.jpg", "#{file_route}original-testImage2.jpg", "#{file_route}doesnt_exist.lol"]


  		mock_auth_token = "12345/678"
  		mock_auth_token_to_file = mock_auth_token.gsub(/(\/+)*/, '')

	  	if File.exist?("#{Rails.root}/tmp/download_log-#{mock_auth_token_to_file}.txt")
	      File.open("#{Rails.root}/tmp/download_log-#{mock_auth_token_to_file}.txt", "w+t") do |file|
	        file.close
	        File.unlink(file)
	      end
	    end

  		original_directory_file_count = Dir["#{Rails.root}/tmp/*"].length

  			#POST from the view, requesting the files to download.

		  	post admin_download_file_path(@admin), params: {'authenticity-token': mock_auth_token, files: ActiveSupport::JSON.encode(files_array)}, xhr: true #{'authenticity-token': mock_auth_token, files: files_array}# files: files_array}
		  
		  	assigns(:operation_results)
		  	assigns(:temp_zip)
	  		#GET_OBJECT is done by the controller. Our job is to check that the controller actions are having no errors.

		  	#files_array.each do |file|
		  	
		  		#Test if the download_log exists
		  		assert File.file?("#{Rails.root}/tmp/download_log-#{mock_auth_token_to_file}.txt")
		  
				# create an empty array that will contain the names of the files that were added to the zip file.
				zip_file_contents = []
				#open the zip file
		  		Zip::File.open(assigns(:temp_zip)) do |zip_file|
		  			#check that the size of the zip file entry is equal to the original file size of the fixture
		  			# #size is the correct method, as #compressed_size is the final size of the zipped entry.
		  			zip_file.each do |zip_entry|
	
		  				uploaded_images_array.each do |file| #This block searches the name of the
		  													 #compares the original size of the file in the zip archive to its 
		  													 #corresponding fixture uploaded tempfile.
		  										
		  					if "#{file_route}original-#{file.original_filename}" === zip_entry.name #refactor this pls
						#	  debugger
		  						assert_equal zip_entry.size, file.size
		  						zip_file_contents << zip_entry.name
		  					end

		  				end
		  				#push the entry name to the previously created array for comparison purposes
		  			
		  			end

		  		end
				   
		  		# Does the zip file contain the same files as the files requested in the POST request?
		  		assert_equal zip_file_contents, files_array.slice(0..-2) #Has to exclude the unexistant download! chop off the last one.
		  		
		 	
		  #	end

		  	#Test that the files still exist. 

		  	# This test fails randomly, probably has to do with timing. Leaving it commented until I figure out a way to make it
		  	# consistent

		  	#assert_equal (original_directory_file_count + files_array.length + 2), Dir["#{Rails.root}/tmp/*"].length

		  	#Test that the download_log has the correct information.

		    download_log = File.open("#{Rails.root}/tmp/download_log-#{mock_auth_token_to_file}.txt", "r")
  			download_log.rewind
  			assert_equal download_log.read, assigns(:operation_results).join

	  	


	#START TEST => DOWNLOADS_INFO

	#operation_result is not usable on the get request.
	flash_value = assigns(:operation_results).join

	get admin_download_file_path, params: {'authenticity-token': mock_auth_token}

	assert_select 'div.alert' do |element|
		assert_equal element.inner_text, flash_value.html_safe
	end

    #START TEST => DELETIONS

    	#DELETE request from the view, detailing files to delete.

    	delete admin_delete_file_path, params: {files: files_array}

      #Asserts whether or not the files we uploaded on the first test were actually deleted.
    	uploaded_images_array.each do |image|

	  		#same variables as the upload
	        image_file = image.tempfile 
	        image_file_name = image.original_filename
	        image_file_route = file_route 

       		should_be_empty = s3.list_objects(bucket: ENV['AWS_S3_BUCKET'], marker: '#{image_file_route}').contents ## key: "#{image_file_route}#{image_file_name}").contents
    		should_be_empty = should_be_empty.select{|entry| entry.key === "#{image_file_route}#{image_file_name}"}.map(&:key)
    		assert should_be_empty.empty?

    	end


	end

 end


end