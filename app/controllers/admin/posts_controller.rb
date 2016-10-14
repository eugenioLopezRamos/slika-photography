class Admin::PostsController < ApplicationController
    before_action :logged_in_user
    before_action :can_destroy_post, only: :destroy
    before_action :can_update_post, only: [:edit, :update]

    before_action :preprocess_img_tags, only: [:create, :update]
    
    def new
        @post = Post.new
    end
    
    def create
        @post = current_user.posts.build(post_params)
        if @post.save
            flash[:success] = "Post successfully created"
            redirect_to admin_user_url(current_user)
        else
            flash[:danger] = "Post could not be saved"
            render 'new'
        end
    end
    
    def edit
        @post = Post.find_by(slug: params[:slug])
    end
    
    def update
        @post = Post.find_by(slug: params[:slug])
        @post.update_attributes(post_params)
        if @post.save
            flash[:success] = "Changes have been saved"
            redirect_to admin_user_path(current_user)
        else
            flash[:danger] = "Saving changes failed"
            redirect_to admin_user_path(current_user)
        end
    end
    
    
    def show
        @post = Post.find_by(slug: params[:slug])

    end
    
    
    def destroy
        @post = Post.find_by(slug: params[:slug])
        @post.destroy
        flash[:success] = "Post deleted"
        redirect_to admin_user_path(current_user)
    end
    



    private
    
    def post_params
        params.require(:post).permit(:title, :content)
    end
    
    def can_destroy_post
        if current_user.id === Post.find_by(slug: params[:slug]).user_id || current_user.admin?
            return true
        else
            redirect_to admin_user_path(current_user)
        end
    end
    
    def can_update_post
      if current_user.id == Post.find_by(slug: params[:slug]).user_id
        return true
      else
        flash[:danger] = "You are not authorized to do this"
        redirect_to admin_user_path(current_user)
      end
    end

    def preprocess_img_tags
      
        content = params[:post][:content]

        content_img_tags = Nokogiri.HTML(content).css('img') #Array with all the img tags and their attributes

        #these three are not used in this process itself, but are provided to make testing easier/more understandable (also avoids making double the requests to S3)
        @all_img_data_sizes = [] 
        @all_img_data_route = []
        @all_img_data_file = []





        content_img_tags.each_with_index do |img, index|
            
            initial_img = img.to_xhtml

            full_src = img['src'].split("/")
     
          #  if full_src[0] != "" #if the first item of the src attribute is different from "" (as would happen, for example, on an external url, stop the process)
           #     return
           # end

            
            full_src = full_src.slice!(1..-1)
         
            full_file = full_src.slice!(-1)
            
            @route = "#{full_src.join("/")}"
            @file = full_file.split("-").slice!(1..-1).join("-") #removes the version prefix => original-myimage-img-foo.jpg -> myimage-img-foo.jpg

            s3 = Aws::S3::Client.new

            @sizes = s3.list_objects(bucket: ENV['AWS_S3_BUCKET'], marker: "#{@route}").contents.map(&:key)
            @sizes = @sizes.select {|entry| entry.match("#{@route}/#{/\d{1,4}-/}#{@file}")} # route/{1 to 4 digits}-filename

            if @sizes.empty?
                
                return

            end

          
            @sizes.map! do |size|
                
                size.gsub!("#{@route}/", "")
                size.split("-").slice!(0) #gets, for example, the 480 from "480-filename.jpg" (that is, the img version part of the filename)
                
            end
            
            @sizes.sort! {|a,z| z.to_i <=> a.to_i}

            @all_img_data_route.push ActionController::Base.helpers.asset_path("#{@route}/")
            @all_img_data_file.push "#{@file}"
            @all_img_data_sizes.push @sizes
            
            img["data-route"] = ActionController::Base.helpers.asset_path("#{@route}/")#"#{asset_host/@route}"
            img["data-file"] = "#{@file}"
            img["data-sizes"] = "#{@sizes}"

          
            content.gsub!(initial_img, img.to_xhtml)

        end
                    
  
    end
  
end
