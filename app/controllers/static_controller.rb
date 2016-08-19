class StaticController < ApplicationController
  def home
    #respond_to do |format|
   # format.html {render 'home'}
   # end
   redirect_to '/home'
  end

  def show
    respond_to do |format|
    format.html {render 'home'}
    format.js
    end
  end
  
  def show_models
    respond_to do |format|
    format.html {render 'home'}
    format.js
    end
  end
  
  def show_urban
    respond_to do |format|
    format.html {render 'home'}
    format.js
    end
  end
  
  def show_events
    
  end
  
  def show_contact
    
  end

  def show_blog
    @tab = params[:tab]
    respond_to do | format |
    format.html {render 'home', locals: {tab: @tab}}
    end
  end
  
  
  def show_404

  end
  
  




  def admin
    

  end
  
end