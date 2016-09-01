class StaticController < ApplicationController
  def home
   redirect_to '/home'
  end

  def show
    respond_to do |format|
    format.html {render 'home'}
    format.js {@parameters = params}
    end
  end
  
  def retrieve_posts
    @post = params[:post_id]
    render partial: 'admin/posts/post'
  end

  def show_404

  end

end