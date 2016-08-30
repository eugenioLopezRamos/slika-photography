class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  private
  
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in"
      redirect_to admin_login_path
    end
  end
  
  def admin_user
    unless current_user.admin?
    flash[:danger] = "You do not have permission to do this"
    redirect_to admin_user_path(current_user)
    end
  end
  
  def logged_in_admin_user 
      unless logged_in?
      flash[:danger] = "Please log in"
      redirect_to admin_login_path #and return
      end
      
      if logged_in? && !admin_user
        flash[:danger] = "You are not an admin"
        redirect_to admin_user_path(current_user)
      end
  end
  
  def can_delete_post
    if current_user.id === Post.find(params[:id]).user_id || current_user.admin?
      return true
    else
      redirect_to admin_user_path(current_user)
    end
    
  end
  
  
  
end
