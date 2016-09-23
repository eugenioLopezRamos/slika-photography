class Admin::AdminController < ApplicationController

    def login
        redirect_to '/admin/login'
    end

    def upload_show
    	render 'admin/upload/upload_show'
    end


  def upload_file
   # debugger
    if params[:image].nil?
    
      return
    else
     s3 = Aws::S3::Client.new
     image_file = params[:image].open
     image_file_name = params[:image].original_filename
     image_file_route = params[:file_route] #To be implemented, should also come from the front end


    File.open(image_file, 'rb', :encoding => 'binary') do |file|
      s3.put_object(bucket: ENV['AWS_S3_BUCKET'], key: "#{image_file_route}#{image_file_name}", body: file)
    end

    uploaded_file_route = s3.list_objects(bucket: ENV['AWS_S3_BUCKET'], delimiter: image_file_route).contents
    uploaded_file_route = uploaded_file_route.select{ |entry| entry.key === "#{image_file_name}" }.map(&:key)


    flash.now[:info] = "File successfully uploaded. Address: #{uploaded_file_route.to_s.gsub(/\"*\[*\]*/, '')}"
    render 'admin/upload/upload_show'
    end

  end

  def download_file

    selected_file = params[:file]
    get_file(selected_file)

  end



  def delete_file
    #need to add somesort of authentication so not everybody can delete files


    files_array = params[:files]


    to_delete = []

    files_array.each do |file|

      string_to_add = {key: file}
      to_delete.push string_to_add

    end

    s3 = Aws::S3::Client.new
    s3.delete_objects({
      bucket: ENV['AWS_S3_BUCKET'],
      delete: {
        objects: to_delete,
      },

      })


    #here I should use a call to the AWS SDK to delete files

    flash.now[:info] = "File successfully deleted"
    render 'admin/upload/upload_show'
  end

  private

  def authenticate_request
    #To be implemented - request authentication with tokens
      authenticate_or_request_with_http_token do |token, options|
        User.find_by(auth_token: token)
      end
  end


#http://stackoverflow.com/questions/18232088/in-ruby-on-rails-after-send-file-method-delete-the-file-from-server

  def get_file(selected_file)
      s3 = Aws::S3::Client.new
      #need to test for unexisting files and give an error message if file is not found
      gotten_file = Tempfile.open(['filename'], :encoding => 'binary') do |file|
                      resp = s3.get_object({bucket: ENV['AWS_S3_BUCKET'], key: selected_file}, target: file)
                      File.open(file)

                    end

      send_file(gotten_file, type: 'image/jpg', disposition: 'attachment', filename: 'leoPhoto.jpg')

  end

end
