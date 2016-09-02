class StaticController < ApplicationController
  def home
   redirect_to '/home'
  end

  def show
    respond_to do |format|
    format.html {render 'home'}
    format.js {@parameters = params}
    format.json 
    end
  end
  
  def retrieve_posts
    if params[:post_id] == "last" then @post= Post.last 
      else @post = Post.find(params[:post_id])
    end
    render partial: 'admin/posts/post'
  end

  def show_404

  end

end