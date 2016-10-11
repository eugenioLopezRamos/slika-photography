class StaticController < ApplicationController
  def home
   redirect_to '/home'
  end


  

  def show
    if image_tabs.include? params[:tab]
      slider_tabs_images
    end

    render 'home'
  end

  
  def retrieve_posts
    if params[:slug] == "last" then @post= Post.last 
      else @post = Post.find_by(slug: params[:slug])
    end
    render partial: 'admin/posts/post'
  end

  
  def retrieve_tabs


    #tab is blogTab
    if params[:tab] === "blogTab"
      if params[:id] === "undefined" || params[:id].nil?
        @post = Post.last
      else
        @post = Post.find_by(slug: params[:id]) 
      end

    end

    #tab is not blogTab
    if params[:tab] != "blogTab" then
      if params[:id] === "undefined" || params[:id].nil?
        @id = "1"
      else 
        @id = params[:id]
      end

    #check if the tab is a *Slides tab
    if image_tabs.include? params[:tab] #image_tabs comes from from application_helper 
      slider_tabs_images #determines which images to put on the tab
    end

    end

    render partial: 'layouts/jumbotron'   
  end


  def slider_tabs_images

  @assets_dir = 'images/' #base directory of all assets
  @image_dir = "#{params[:tab].gsub('Tab', 'Slides')}"
  @tab_value = @image_dir.gsub("Slides", "Slide")
  #used to be 'app/assets/images/' 
  @active_slide_class = 'active-slide' #HTML class to be used for the active slide - This is used by the javascript and css to display and style things.
  
  @full_dir = "#{@assets_dir}#{@image_dir}" #image_dir is provided by the respective partial
  @public_folder = "public/" #Yes it's dumb I have to add and remove this but the rails image Helpers wont play nice with my S3 file structure

   #  @full_dir = asset_path @full_dir
    # @active_slide = 1 # 1-indexed number of the active slide. Later it will be dynamic
#debugger

    #Use the @counter to determine what slide is the active one and set its class below.
  @counter = 0

  if params[:id].nil? #params :id  comes from /tabs_retriever which is accessed by AJAX calls
        @active_slide = 1
  else
      @active_slide = params[:id] 
      @active_slide = @active_slide.to_i
  end

    
  #@files_in_folder = Dir[File.join(@full_dir, '**', '*')].count { |file| File.file?(file) } #Counts the amount of files in the directory determined by the active tab
  #the loop below loops creates @files_in_folder amount of divs that contain an image element, whose source is @full_dir/<NUMBER OF SLIDE>.jpg. Additionally, for the active slide, it adds the @@active_slide_class value

  #s3::list_objects(bucket:ENV['AWS_S3_BUCKET'], prefix: 'images/peopleSlides').contents.map(&:key).slice(1..-1).count

  #does a request to our s3 bucket using the AWS-SDK. Prefix is the "directory", contents is the part of the full response that lists the files inside
  #our bucket that match our constraints. In this case, the "prefix" helps us get only the "directory" we want within the bucket.
  #contents.map(&:key) presents only the key (so its like the root + included files). the slice method is added to exclude the 0 index, which is the "root" of the directory

  if Rails.env.production?
    s3 = Aws::S3::Client.new
    @files_in_folder = s3::list_objects(bucket:ENV['AWS_S3_BUCKET'], prefix: @full_dir).contents.map(&:key)
 #this below is wrong.
    @files_in_folder.each do |file|
     #   file.gsub!("#{@full_dir}/", "")#remove the dir from the key (file) name
    end
    #@files_in_folder.delete_if {|file| "#{file}" === ""}
  else
    @full_dir = "#{@public_folder}#{@full_dir}"
    @files_in_folder = Dir.entries("#{@full_dir}/") - %w[. ..] #remove dots.
    @files_in_folder.map! { |file| file = "#{@full_dir}/#{file}" }
  end

  #currently in dev the background is taken from public/images/background and the rest of iamges are taken from Rails.root/images
  #this is due to me prioritizing the route format of the S3 bucket.

  #s3 = Aws::S3::Client.new
  #@files_in_folder = s3::list_objects(bucket:ENV['AWS_S3_BUCKET'], prefix: @full_dir).contents.map(&:key)
  

  @original_files = Array.new #will contain the base filename of each photo
  @sizes_per_file = Hash.new #A hash with the following structure = "filename" => [available image sizes] } 

  @files_in_folder.select{ |key| key.start_with?("#{@full_dir}/original-")}.map do |key|

      base_file = key.gsub("#{@full_dir}/original-", '')
      versions = Array.new #Will include all the available versions of the file (depending on base_file dimensions)

      @files_in_folder.select { |file_route| file_route.include?(base_file) }.map do |version|

        #base_filename as hashkey, [version] as value
        to_add = version.gsub("#{@full_dir}/", '') #removes the file route
        to_add = to_add.gsub("-#{base_file}", '') #removes the dash that separates the base filename and the filename itself
        
        if to_add != "original" && to_add != size_breakpoints[-1].to_s && to_add != base_file #size_breakpoints comes from ApplicationHelper 
        #since it's used in the admin pages(when uploading) and in this public view that belongs to another controller.

        #this admittedly big if statement checks that the to_add value isn't == "original", isn't the LAST item of size_breakpoints (the thumbnail size)
        # and isn't equal to the base file name, just in case.
         versions.push to_add 
        end 

      end

      @original_files.push base_file #adds the base file to the original files Array
      @sizes_per_file[base_file] = versions.sort! {|a,z| z.to_i <=> a.to_i } #creates an entry in the @sizes_per_file hash for the file we just added, listing
      #its available sizes

  end
 # debugger
  @original_files.sort! {|a,z| a.to_i <=> z.to_i}

  end


  def redirect
    @tab = request.env['PATH_INFO'].downcase!
    begin
      redirect_to @tab
    rescue
      redirect_to "/404" and return
    end   
  end




  def show_404

  end

end