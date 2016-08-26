class Admin::PostsController < ApplicationController
    before_action :logged_in_user
    
    def new
        @post = Post.new
    end
    
    def create
        @post = current_user.posts.build(post_params)
        if @post.save
            flash[:success] = "Post successfully created"
            redirect_to admin_user_url(current_user)
        else
            render 'new'
        end
    end
    
    def show
        @post = Post.find(params[:id])
    end
    
    
    private
    
    def post_params
        params.require(:post).permit(:title, :content)
    end
end
