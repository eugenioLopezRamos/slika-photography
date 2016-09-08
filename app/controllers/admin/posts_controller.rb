class Admin::PostsController < ApplicationController
    before_action :logged_in_user
    before_action :can_destroy_post, only: :destroy
    before_action :can_update_post, only: [:edit, :update]  
    
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
    
end
