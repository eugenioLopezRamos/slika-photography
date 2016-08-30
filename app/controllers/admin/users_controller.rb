class Admin::UsersController < ApplicationController
  before_action :logged_in_admin_user
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end
  
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_url(current_user)
      flash[:success] = "User successfully created"
    else
      render 'new'
    end
  end
  
  private
  
    def user_params
      params.require(:admin_user).permit(:id, :name, :email, :password, :password_confirmation)
    end
    
    # Confirms an admin user.
    def admin_user
      current_user.admin?
    end
    
    #confirms user being logged in AND being an admin user
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
    
end
