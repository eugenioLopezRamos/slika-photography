class Admin::PostsController < ApplicationController
    
    def new
        @post = Post.new
    end
    
    def create
        
    end
    
    def show
        @post = Post.find(params[:id])
    end
    
end
