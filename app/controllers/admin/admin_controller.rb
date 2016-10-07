class Admin::AdminController < ApplicationController

require 'zip'
require 'mini_magick'
before_action :logged_in_user
before_action :logged_in_admin_user
before_action :create_download_log, only: :download_file

  def size_breakpoints

      [2000, 1500, 1100, 900, 700, 480, 100] 

    #defines the breakpoints. If the img_width is higher than a given breakpoint, reduce it to all breakpoints below it
 
    #        img_width > 2000 ? -> 2000 & 1500 & 1100 & 900 & 700 & 480 & 100
    # 2000 > img_width > 1500 ? -> 1500 & 1100 & 900 & 700 & 480 & 100
    # 1500 > img_width > 1100 ? -> 1100 & 900 & 700 & 480 & 100
    # 1100 > img_width > 900 ? -> 900 & 700 & 480 & 100
    # 900 > img_width > 700 ? -> 700 & 480 & 100
    # 700 > img_width > 480 ? -> 480 & 100
    # 480 > img_width ? -> img_width & 100

  end

  def login
    redirect_to '/admin/login'
  end

  def files_show
    render 'admin/files/files'
  end


  def optimize_images #(*images_array)
    
    @images_to_optimize = params[:image]

    @to_upload = []

    @images_to_optimize.each do |image|

      img = MiniMagick::Image.open(image.path) #Need to open the file to check height/width

        img_height = img[:height] #height of the image
        img_width = img[:width] #width

     
      
     # orig_file = File.open(image.tempfile.path, 'rb')
     #File.open(image.tempfile.path, 'rb') -> write en otro archivo -> cerrar el original -> rewind.

      base_file = File.open(image.tempfile.path, 'rb')

      new_file = File.open("#{Rails.root}/tmp/original-#{image.original_filename}", 'wb')

      file_data = base_file.read()

      new_file.write(file_data)

      @to_upload << new_file

      applicable_widths = []
      shortened_breakpoints = size_breakpoints.slice(0..-2) #ignores the last size, the thumbnail, since thats always included

      shortened_breakpoints.each_with_index do |width, index| #last size (thumbnail size, the smallest) is excluded
        #since it will always be included
      
        # width.next returns the next value ie the next integer, not the next element of the array

        if img_width > shortened_breakpoints[0] #img_width < shortened_breakpoints[0] && img_width >= shortened_breakpoints[-1]   #smaller than the first (biggest) and larger than the last (smallest)
          applicable_widths << shortened_breakpoints[0]
        elsif (!shortened_breakpoints[index + 1].nil? && img_width > shortened_breakpoints[index + 1])
          applicable_widths << shortened_breakpoints[index + 1]
        elsif img_width<shortened_breakpoints[-1] && shortened_breakpoints[index + 1].nil?
          #  debugger
            applicable_widths << img_width

        end #end if img_width > size
      
      end

      #adds the thumbnail
      applicable_widths << size_breakpoints[-1]

      #create blurry preload image
      #not going to do it, It's probably not worth it (since it will do 2 downloads - I'll use a loading anim in the view and the 
      # retrieve the appropiate version w/ AJAX)

        applicable_widths.each do |app_width|

          MiniMagick::Tool::Convert.new do |convert| #convert the images
            destination_file = File.open("#{Rails.root}/tmp/#{app_width}-#{image.original_filename}", 'w+b')

            convert << image.tempfile.path

            convert.interlace "plane"
            convert.quality "80"
            new_height = img_height * (app_width.to_f / img_width.to_f) #otherwise it's zero because integers.
            convert.resize("#{app_width}x#{new_height}")       

            convert << destination_file.path #"#{Rails.root}/tmp/temp-#{image.original_filename}" 
          
            @to_upload << destination_file #adds file to the array to be uploaded when the original function continues
 
          end #ends minimagick block

        end #app_width do
          
            image.tempfile.close
            image.tempfile.unlink
       end #end @img_to_optimize
   
       return @to_upload
       
  end

  def upload_file
    
    # need to add server side check for image sizes. Probably best to check for total > 100mb
    @total_size_mb = 0
 
    if Rails.env.test?
      @max_size_upload_mb = 5 #Max upload 5mb on test env
    else 
      @max_size_upload_mb = 50 #Otherwise its 50mb
    end

    if !params[:image].nil?
      params[:image].each do |image| 
        @total_size_mb += image.tempfile.size/1024/1024
      end
    end

    if params[:image].nil? #Reject empty uploads

      flash.now[:error] = "No files selected!"
      render partial: '/admin/flash_messages'
      return
    elsif @total_size_mb > @max_size_upload_mb     #Reject uploads over a certain size

      flash.now[:error] = "Upload size exceeds the maximum!"
      render partial: '/admin/flash_messages'
      return
    else #Go ahead and upload
      
      s3 = Aws::S3::Client.new #create the client
      
      response_message = "#{"File".pluralize(params[:image].length)} successfully uploaded. #{"Location".pluralize(params[:image].length)}:<br />" 
      #need to change that message, not always will all files be successfully uploaded

        optimized_array = optimize_images
       
        optimized_array.each do |image|
          
          image_file = image 
          image_file_name = File.basename(image_file)
          image_file_route = params[:file_route] #The route is unique anyways, can't upload to 2 folders at once

          File.open(image_file, 'rb', :encoding => 'binary') do |file|
            s3.put_object(bucket: ENV['AWS_S3_BUCKET'], key: "#{image_file_route}#{image_file_name}", body: file)
          end #file open end
          
          uploaded_file_route = s3.list_objects(bucket: ENV['AWS_S3_BUCKET'], marker: image_file_route).contents
          uploaded_file_route = uploaded_file_route.select{ |entry| entry.key === "#{image_file_route}#{image_file_name}"  }.map(&:key)

          response_message << uploaded_file_route.to_s.gsub(/\"*\[*\]*/, '') << "<br />"
          
          image.close
          File.unlink(image)

        end # @optimized_array end

      flash.now[:info] = response_message.html_safe 
      render partial: '/admin/flash_messages'
      end #else end

  end


  def download_file

  #  download_messages_log = Tempfile.new("download_log.txt", "#{Rails.root}/tmp")
    @operation_results = []
    downloaded_file_count = 0
   
    selected_files = Array.new
    files_array = ActiveSupport::JSON.decode params[:files]
    #same as delete, check if every item to see if it's a folder, if it is s3.list_objects, add all children keys to the array
    #then array.uniq! it up

    s3 = Aws::S3::Client.new

    files_array.each do |file|

      if is_folder?(file) #checks if |file| is a folder - if it is, get all children...
        all_children = s3.list_objects(bucket: ENV['AWS_S3_BUCKET'], prefix: file).contents.map(&:key) #gets all of the folder's children
      

        all_children.each do |child| #and adds them to selected_files

          if !is_folder?(child)
            child_to_add = child
            selected_files.push child_to_add
          end

        end

      else 
        string_to_add = file #adds each file to the selected_files
        selected_files.push string_to_add
      end

    end

    #debugger
    selected_files.uniq!

 

    @temp_zip = Tempfile.new('temp.zip', "#{Rails.root}/tmp")

    Zip::OutputStream.open(@temp_zip) {|zos|}

      selected_files.each do |sel_file| #need to fix this on folders.
        Tempfile.open("tmpfile", "#{Rails.root}/tmp", :encoding => 'binary') do |file|
          begin 

            resp = s3.get_object({bucket: ENV['AWS_S3_BUCKET'], key: sel_file}, target: file)

            rescue Aws::S3::Errors::ServiceError => e
            # raise e.message, :status => 404
            #render :json => {"message" => e.message}, :status => 404
            @operation_results.push "<br />#{sel_file}: #{e.message.gsub('key', 'file')}<br />" 
           # render partial: 'admin/flash_messages', :status => 404
            # this should have more :status codes according to the possible errors S3 can throw
          end #begin close

          if !resp.nil?
         
            File.open(file) do |file| #change file to temp_file later
              Zip::File.open(@temp_zip.path, Zip::File::CREATE) do |zipfile|
                zipfile.add(sel_file, file.path)
                downloaded_file_count = downloaded_file_count + 1
              end #zip block close
            end #file open close
          
          if Rails.env != "test" #Don't delete the files when testing!
            file.close
            file.unlink
          end
        end # Tempfile.open close
      end #selected_files.each close
    end #end Zip::OS

    ensure
     if !@temp_zip.nil?
      File.open(@temp_zip.path, 'r') do |zip|
        send_data(zip.read, disposition: 'attachment')
      end
      @operation_results.push "#{downloaded_file_count} #{'file'.pluralize(downloaded_file_count)} zipped and sent"
      
      if Rails.env != "test" #Don't delete the files when testing!
        @temp_zip.close
        @temp_zip.unlink
      end

      @operation_results.each do |message|
        @download_log.write("#{message}") 
      end

      @download_log.rewind
      @download_log.close
     end



  end

  def req_download_file_info

    token_param = params[:'authenticity-token'].gsub(/(\/+)*/, '')

    download_log = File.open("#{Rails.root}/tmp/download_log-#{token_param}.txt", "r")
 
    download_log.rewind

    if download_log.read != ""
      download_log.rewind
      flash.now[:info] = "#{download_log.read}"
      render partial: 'admin/flash_messages'
    elsif download_log.read === ""
      flash.now[:info] = "There are no messages"
      render partial: 'admin/flash_messages'
    else
      flash.now[:danger] = "Sorry, we could not access the messages log"
      render partial: 'admin/flash_messages'
    end

      download_log.close
    ensure

    #  if Rails.env != "test"
        File.unlink(download_log)
   #   end

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

  def create_download_log
    #remove all "/" characters from the authenticity token, they cause the system to believe it's a new directory(and thus, file creation fails).
    #Without the "/" this string is still unique enough for us to use as a name for our pseudo temp file, especially since it will be
    #deleted shortly after anyways.

    token_param = params[:'authenticity-token'].gsub(/(\/+)*/, '')

    #Just in case, checks for a file with the same name and deletes it.
    if File.exist?("#{Rails.root}/tmp/download_log-#{token_param}.txt")
      File.open("#{Rails.root}/tmp/download_log-#{token_param}.txt", "w+t") do |file|
        file.close
        File.unlink(file)
      end
    end

    #create a new log file to be used by #download_file to store messages
    @download_log = File.open("#{Rails.root}/tmp/download_log-#{token_param}.txt", "w+t")
        
  end


end
