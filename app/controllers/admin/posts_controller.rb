class Admin::PostsController < ApplicationController
    before_action :logged_in_user
    before_action :admin_user, only: [:destroy]
    
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
    
    def show
        @post = Post.find(params[:id])
    end
    
    
    def destroy
        @post = Post.find(params[:id])
        @post.destroy
        flash[:success] = "Post deleted"
        redirect_to admin_user_path(current_user)
    end
    
    
    
    
    private
    
    def post_params
        params.require(:post).permit(:title, :content)
    end
end
