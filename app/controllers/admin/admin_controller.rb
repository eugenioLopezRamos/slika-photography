class Admin::AdminController < ApplicationController

  def login
      redirect_to '/admin/login'
  end

  def upload_show
    render 'admin/upload/upload_show'
  end


  def upload_file

    if params[:image].nil?
      flash.now[:error] = "No files selected!"
      render partial: '/admin/flash_messages'
      return
    else

      s3 = Aws::S3::Client.new
      #image_file = params[:image].open
     # image_file_name = params[:image].original_filename
     # image_file_route = params[:file_route]

     response_message = "#{"File".pluralize(params[:image].length)} successfully uploaded. #{"Location".pluralize(params[:image].length)}:<br />" 
 
      params[:image].each do |image|
        image_file = image.open
        image_file_name = image.original_filename
        image_file_route = params[:file_route] #The route is unique anyways, can't upload to 2 folders at once

        File.open(image_file, 'rb', :encoding => 'binary') do |file|
          s3.put_object(bucket: ENV['AWS_S3_BUCKET'], key: "#{image_file_route}#{image_file_name}", body: file)
        end
        
        uploaded_file_route = s3.list_objects(bucket: ENV['AWS_S3_BUCKET'], marker: image_file_route).contents
        uploaded_file_route = uploaded_file_route.select{ |entry| entry.key === "#{image_file_route}#{image_file_name}"  }.map(&:key)

        response_message << uploaded_file_route.to_s.gsub(/\"*\[*\]*/, '') << "<br />"

      end




      flash.now[:info] = response_message.html_safe #{}"File successfully uploaded. Location: #{uploaded_file_route.to_s.gsub(/\"*\[*\]*/, '')}".html_safe
      render partial: '/admin/flash_messages'
      end

  end


#<ActionController::Parameters {"utf-8"=>"✓", "authenticity-token"=>"daR+aUgj/g3MB8SYWgH0tjsd5Of7pZGUlyjVTUBok1KNnvMs2AFt2N89ZOLf2vCnh8Z9cOz7LQveLyzB8U5/MA==",
# "file_route"=>"", 
#"image"=>[#<ActionDispatch::Http::UploadedFile:0x00557e27d87cc8 @tempfile=#<Tempfile:/tmp/RackMultipart20160925-26687-1jsr303.jpg>, @original_filename="camera-background.jpg", @content_type="image/jpeg", @headers="Content-Disposition: 
#form-data; name=\"image[]\"; filename=\"camera-background.jpg\"\r\nContent-Type: image/jpeg\r\n">, 



#<ActionDispatch::Http::UploadedFile:0x00557e27d87a20 @tempfile=#<Tempfile:/tmp/RackMultipart20160925-26687-1p9izov.jpg>, @original_filename="camera-background2.jpg", @content_type="image/jpeg", @headers="Content-Disposition: form-data; name=\"image[]\"; filename=\"camera-background2.jpg\"\r\nContent-Type: image/jpeg\r\n">, #<ActionDispatch::Http::UploadedFile:0x00557e27d87228 @tempfile=#<Tempfile:/tmp/RackMultipart20160925-26687-7htwr6.jpg>, @original_filename="camera-background (1).jpg", @content_type="image/jpeg", @headers="Content-Disposition: form-data; name=\"image[]\"; filename=\"camera-background (1).jpg\"\r\nContent-Type: image/jpeg\r\n">, #<ActionDispatch::Http::UploadedFile:0x00557e27d87138 @tempfile=#<Tempfile:/tmp/RackMultipart20160925-26687-1qk07u2.jpg>, @original_filename="camera-background (2).jpg", @content_type="image/jpeg", @headers="Content-Disposition: form-data; name=\"image[]\"; filename=\"camera-background (2).jpg\"\r\nContent-Type: image/jpeg\r\n">, #<ActionDispatch::Http::UploadedFile:0x00557e27d86990 @tempfile=#<Tempfile:/tmp/RackMultipart20160925-26687-97g570.jpg>, @original_filename="camera-background (5).jpg", @content_type="image/jpeg", @headers="Content-Disposition: form-data; name=\"image[]\"; filename=\"camera-background (5).jpg\"\r\nContent-Type: image/jpeg\r\n">], "controller"=>"admin/admin", "action"=>"upload_file"}




















  def download_file

    selected_file = params[:file]
    get_file(selected_file)

  end



  def delete_file
    #need to add somesort of authentication so not everybody can delete files
    files_array = params[:files]
    to_delete = []
    s3 = Aws::S3::Client.new
    #this controller needs to detect whether the selected item is a folder or a file, and if it's a folder,
    #delete the folder item and all of its children


    files_array.each do |file|
      if is_folder?(file)
        all_children = s3.list_objects(bucket: ENV['AWS_S3_BUCKET'], marker: file).contents.map(&:key) #gets all of the folder's children

        all_children.each do |child| #and adds them in key: value pairs to the "to_delete" array
          child_to_add = {key: child}
          to_delete.push child_to_add
        end

      else 
        string_to_add = {key: file} #adds each file to the "to_delete" array
        to_delete.push string_to_add
      end
  end

    to_delete.uniq! #eliminates duplicates, thanks ruby!

    #change objects: to_delete

    resp = s3.delete_objects({ #delete the files in the bucket
        bucket: ENV['AWS_S3_BUCKET'],
        delete: {
          objects: to_delete,
        },

        })


      flash.now[:info] = "#{to_delete.length} #{"file".pluralize(to_delete.length)} deleted.<br />#{"file".pluralize(to_delete.length)}:<br /> #{resp.deleted.map(&:key).join("<br/>")}".html_safe 

      if resp.errors.length > 0 
        flash.now[:danger] = "An error has happened, please check server logs"
      end

      render partial: '/admin/flash_messages'
  end



  def is_folder?(file)
    if file.match(/([\w]+[.]*[\w]+\/)*/) && file.gsub(/(\w*[.]*[\w]+\/)*/, '') === '' # file matches the Folder Regex AND if you replace the
      #folder regex with "" it becomes "" -> its a folder route instead of a file route
      #gsub is intentionally different, else there's problems when you input, for example file = "2/".gsub(/([\w]+[.]*[\w]+\/)*/) => "2/" => is_folder? => false
      #when it's actually a folder.
      true
    else #Any other case is assumed to be a file
      false
    end

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

                begin 
                  resp = s3.get_object({bucket: ENV['AWS_S3_BUCKET'], key: selected_file}, target: file)
                rescue Aws::S3::Errors::ServiceError => e
                 # raise e.message, :status => 404
                  #render :json => {"message" => e.message}, :status => 404
                  flash.now[:danger] = e.message.gsub('key', 'file');
            
                  render partial: 'admin/flash_messages', :status => 404
                  # this should have more :status codes according to the possible errors S3 can throw

                end

                if !resp.nil?
                  File.open(file)
                end
                
      end
#test/pruebaimages/2%20(1).jpg

#debugger

    if !gotten_file.nil?

      send_file(gotten_file, type: 'image/jpg', disposition: 'attachment', filename: 'leoPhoto.jpg') 
    end

  end





end
