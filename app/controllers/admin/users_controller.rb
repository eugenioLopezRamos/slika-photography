class Admin::UsersController < ApplicationController
  

  def new
    if logged_in? && admin_user
    @user = User.new
    else
    flash[:danger] = "You are not allowed to create new users"
    redirect_to admin_user_path(current_user)
    end
  end
  
  def show
    if logged_in?
    @user = User.find(params[:id])
    else
      redirect_to admin_login_path
      flash.now[:danger] = "Please login to access this section"
    end
  end
  
  
  def create
    
    @user = User.new(user_params)
    if @user.save
      log_in @user
      redirect_to admin_user_url(@user)
      flash[:success] = "Welcome!"

    else
     render 'new'
    end
    
  end
  
  private
  
    def user_params
      params.require(:admin_user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # Confirms an admin user.
    def admin_user
     current_user.admin?
    end
    
end
