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
    

    def preprocess_img_tags
      
        content = params[:post][:content]
        replacements = []

        content_img_tags = Nokogiri.HTML(content).css('img') #Array with all the img tags and their attributes
        
        content_img_tags.each_with_index do |img, index|

            initial_img = img.to_html
           
            full_src = img['src'].split("/").slice!(1..-1)

            full_file = full_src.slice!(-1)
            

            @route = "#{full_src.join("/")}/"
            @file = full_file.split("-").slice!(1..-1).join("-") #removes the version prefix => original-myimage-img-foo.jpg -> myimage-img-foo.jpg

            s3 = Aws::S3::Client.new

            @sizes = s3.list_objects(bucket: ENV['AWS_S3_BUCKET'], marker: @route).contents.map(&:key)
            @sizes = @sizes.select {|entry| entry.include? "#{@route}"} #selects only the files in the corresponding route
            @sizes = @sizes.select {|entry| entry.include? "#{@file}"} #and only the files that share names with the corresponding file
            @sizes = @sizes.select {|entry| entry.match("#{@route}#{/\d{1,4}-/}#{@file}")} # route/{1 to 4 digits}-filen.ame
            
            @sizes.map! do |size|
                
                size.gsub!(@route, "")
                size.split("-").slice!(0)
                
            end
          
     

            img['src'] = ""
            img['data-route'] = @route
            img['data-file'] = @file
            img['data-sizes'] = @sizes

           # content_img_tags.to_html.gsub!(initial_img.to_html,img.to_html)
        #    content_img_tags["#{index}"] = img
           # replacements << img
            content.gsub!(initial_img, img.to_html)
            
              debugger
      
        end
                    

     #   puts "2222 #{content_img_tags}"

 
        @modified_content = content
                    

      

        return @modified_content
                    
     
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




    
end
