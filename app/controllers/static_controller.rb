class StaticController < ApplicationController
  def home
   redirect_to '/home'
  end

  def redirect
    @tab = request.env['PATH_INFO'].downcase!
    begin
      redirect_to @tab
    rescue
      redirect_to "/404" and return
    end   
  end
  

  def show
    respond_to do |format|
    format.html {render 'home'}
    format.js

    end
  end
  
  def retrieve_posts
    if params[:slug] == "last" then @post= Post.last 
      else @post = Post.find_by(slug: params[:slug])
    end
    render partial: 'admin/posts/post'
  end
  
  def retrieve_tabs
    if params[:tab] != "blogTab" then
      if params[:id] == "undefined" || params[:id].nil?
        @id = "1"
      else 
        @id = params[:id]
      end

    
    elsif params[:tab] == "blogTab"
      if params[:id] == "undefined" || params[:id].nil?
        @post = Post.last
      else
        @post = Post.find_by(slug: params[:id])
      end
    end
 

    render partial: 'layouts/jumbotron' 
    
  end

  def show_404

  end

end