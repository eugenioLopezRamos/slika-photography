class StaticController < ApplicationController
  def home
   redirect_to '/home'
  end


  

  def show

    if image_tabs.include?(params[:tab]) || params[:tab] === "homeTab"
      assign_images
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
   # if image_tabs.include? params[:tab] #image_tabs comes from from application_helper 
      assign_images #determines which images to put on the tab
  #  end

    end

    render partial: 'layouts/jumbotron'   
  end


  def assign_images

    @assets_dir = 'images/' #base directory of all assets


    if image_tabs.include? params[:tab]
      @image_dir = "#{params[:tab].gsub('Tab', 'Slides')}"
      @tab_value = @image_dir.gsub("Slides", "Slide") #the name of a single slide. Used for the HTML.
    else
      @image_dir = "#{params[:tab].gsub('Tab', '')}" 
      @tab_value = "#{params[:tab].gsub('Tab', '')}"
    end

   
    #@image_dir = "#{params[:tab].gsub('Tab', 'Slides')}" #The folder of each tab's slides.


  
    @active_slide_class = 'active-slide' #HTML class to be used for the active slide - This is used by the javascript and css to display and style things.
    
    @full_dir = "#{@assets_dir}#{@image_dir}" 
    @public_folder = "public/" #Yes it's annoying I have to add and remove this but the rails image Helpers won't play nice with my S3 file structure

    #Use the @counter to determine what slide is the active one and set its class on the view
    @counter = 0

    if params[:id].nil? #params :id  comes from /tabs_retriever which is accessed by AJAX calls - on a full load/reload it will be nil.
          @active_slide = 1
    else
        @active_slide = params[:id].to_i
    end

    #in production, use S3 unless env_keys_missing (aws env keys missing)
    if Rails.env.production? && !env_keys_missing?
        s3 = Aws::S3::Client.new
        @files_in_folder = s3::list_objects(bucket:ENV['AWS_S3_BUCKET'], prefix: @full_dir).contents.map(&:key)
    else #else use the local files.
      puts "S3 keys missing!"
      @full_dir = Rails.env.production? ? "#{@full_dir}" : "#{@public_folder}#{@full_dir}" 
      @files_in_folder = Dir.entries("#{@full_dir}/") - %w[. ..] #remove the dots from the dir result.
      @files_in_folder.map! { |file| file = "#{@full_dir}/#{file}" }
    end
    puts "FILES IN FOLDER #{@files_in_folder}"
    #currently in the dev env the background is taken from public/images/background and the rest of iamges are taken from Rails.root/images
    #this is due to me prioritizing the route format of the S3 bucket.




    ### Photos should be XXX-home-YYY.jpg
    ### where XXX => resolution and YYY is either main for main photo or 1..4 for thumbnails
    @original_files = Array.new #will contain the base filename of each photo
    @sizes_per_file = Hash.new #A hash with the following structure = "filename" => [available image sizes] } 

    @files_in_folder.select{ |key| key.start_with?("#{@full_dir}/original-")}.map do |key| #When uploading images, the original is kept as "original-<FILENAME>"

        @base_file = key.gsub("#{@full_dir}/original-", '')
        versions = Array.new #Will include all the available versions of the file (depending on @base_file dimensions)

        @files_in_folder.select { |file_route| file_route.include?(@base_file) }.map do |version| #Selects all files that include a particular base file name
          #so for example, 480-myimage.jpg, 700-myimage.jpg, 1100-myimage.jpg will all be taken and then added to the "versions" array

          #@base_filename as hashkey, [version] as value
          to_add = version.gsub("#{@full_dir}/", '') #removes the file route
          to_add = to_add.gsub("-#{@base_file}", '') #removes the dash that separates the base filename and the filename itself
          
          if to_add != "original" && to_add != size_breakpoints[-1].to_s && to_add != @base_file #size_breakpoints comes from ApplicationHelper 
          #since it's used in the admin pages(when uploading) and in this controller.

          #this admittedly big if statement checks that the to_add value isn't === "original", isn't the LAST item of size_breakpoints (the thumbnail size)
          # and isn't equal to the base file name, just in case.
          versions.push to_add 
          end 

        end

        @original_files.push @base_file #adds the base file to the original files Array
        @sizes_per_file[@base_file] = versions.sort! {|a,z| z.to_i <=> a.to_i } #creates an entry in the @sizes_per_file hash for the file we just added, listing
        #its available sizes

    end

    @original_files.sort! {|a,z| a.to_s <=> z.to_s}
 
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