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

  def show_404

  end

  def admin
  #loggedin ? enter : redirect_to '/login'
  end
  
end