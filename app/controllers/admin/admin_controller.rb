class Admin::AdminController < ApplicationController

require 'zip'

  def login
      redirect_to '/admin/login'
  end

  def files_show
    render 'admin/files/files'
  end


  def upload_file
    
    # need to add server side check for image sizes. Probably best to check for total > 100mb

    if params[:image].nil?


      flash.now[:error] = "No files selected!"
      render partial: '/admin/flash_messages'
      return
    else
    
      s3 = Aws::S3::Client.new

      response_message = "#{"File".pluralize(params[:image].length)} successfully uploaded. #{"Location".pluralize(params[:image].length)}:<br />" 
 
      params[:image].each do |image|

        image_file = image.tempfile #("#{Rails.root}/tmp")
        image_file_name = image.original_filename
        image_file_route = params[:file_route] #The route is unique anyways, can't upload to 2 folders at once

        File.open(image_file, 'rb', :encoding => 'binary') do |file|
          s3.put_object(bucket: ENV['AWS_S3_BUCKET'], key: "#{image_file_route}#{image_file_name}", body: file)
        end #file open end

        image.tempfile.close
        image.tempfile.unlink
        
        uploaded_file_route = s3.list_objects(bucket: ENV['AWS_S3_BUCKET'], marker: image_file_route).contents
        uploaded_file_route = uploaded_file_route.select{ |entry| entry.key === "#{image_file_route}#{image_file_name}"  }.map(&:key)

        response_message << uploaded_file_route.to_s.gsub(/\"*\[*\]*/, '') << "<br />"

      end # params[:image].each end

      flash.now[:info] = response_message.html_safe #{}"File successfully uploaded. Location: #{uploaded_file_route.to_s.gsub(/\"*\[*\]*/, '')}".html_safe
      render partial: '/admin/flash_messages'
      end #else end

  end


  def download_file

    @@operation_results = []
    uploaded_file_count = 0

    selected_files = ActiveSupport::JSON.decode params[:files]
    s3 = Aws::S3::Client.new

    temp_zip = Tempfile.new('temp.zip', "#{Rails.root}/tmp")

    Zip::OutputStream.open(temp_zip) {|zos|}

      selected_files.each do |sel_file| #need to fix this on folders.
        Tempfile.open("tmpfile", "#{Rails.root}/tmp", :encoding => 'binary') do |file|
          begin 
            resp = s3.get_object({bucket: ENV['AWS_S3_BUCKET'], key: sel_file}, target: file)

            rescue Aws::S3::Errors::ServiceError => e
            # raise e.message, :status => 404
            #render :json => {"message" => e.message}, :status => 404
            @@operation_results.push "#{file.name}: #{e.message.gsub('key', 'file')}<br />" 
           # render partial: 'admin/flash_messages', :status => 404
            # this should have more :status codes according to the possible errors S3 can throw
            end #begin close

          if !resp.nil?
         
            File.open(file) do |file|
              Zip::File.open(temp_zip.path, Zip::File::CREATE) do |zipfile|
                zipfile.add(sel_file, file.path)
                uploaded_file_count = uploaded_file_count + 1
              end #zip block close
            end #file open close
            
          file.close
          file.unlink
        end # Tempfile.open close
      end #selected_files.each close
    end #end Zip::OS

    ensure
     if !temp_zip.nil?
      File.open(temp_zip.path, 'r') do |zip|
        send_data(zip.read, disposition: 'attachment', filename: "download#{Time.zone.now}")
      end
      @@operation_results.push "#{uploaded_file_count} #{'file'.pluralize(uploaded_file_count)} zipped and sent"

      temp_zip.close
      temp_zip.unlink

    end



  end

  def req_download_file_info
    final_message = ""

      @@operation_results.each do |message|

        final_message << message

      end
  
      flash.now[:info] = "#{final_message}"
      render partial: '/admin/flash_messages'
  end

  def delete_file

    #need to add somesort of authentication so not everybody can delete files
    files_array = params[:files]
    to_delete = []
    s3 = Aws::S3::Client.new
    #this controller needs to detect whether the selected item is a folder or a file, and if it's a folder,
    #delete the folder item and all of its children

    files_array.each do |file|
      if is_folder?(file) #checks if |file| is a folder - if it is, adds all of its children to the array to be deleted
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

                
    #  end
#test/pruebaimages/2%20(1).jpg

#debugger



  end





end
