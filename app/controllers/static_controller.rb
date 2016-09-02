class StaticController < ApplicationController
  def home
   redirect_to '/home'
  end

  def show
    respond_to do |format|
    format.html {render 'home'}
    format.js

    end
  end
  
  def retrieve_posts
    if params[:post_id] == "last" then @post= Post.last 
      else @post = Post.find(params[:post_id])
    end
    render partial: 'admin/posts/post'
  end
  
  def retrieve_tabs
    if params[:id] == "undefined" || params[:id].nil?
      @id = "1"
      else 
        @id = params[:id]
    end
    
    if params[:post_id].nil? then @post = Post.last #need to fix this
      else @post = Post.find(params[:post_id])
    end

    render partial: 'layouts/jumbotron' 
    
  end

  def show_404

  end

end