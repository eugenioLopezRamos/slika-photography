class Admin::PostsController < ApplicationController
    before_action :logged_in_user
    
    def new
        @post = Post.new
    end
    
    def create
        
        
    end
    
    def show
        @post = Post.find(params[:id])
    end
    
end
