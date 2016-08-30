class Admin::UsersController < ApplicationController
  before_action :logged_in_user
  before_action :logged_in_admin_user, only: [:new, :create]
  before_action :can_destroy_user, only: :destroy
  
  def index
  end
  
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
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "User has been deleted"
    redirect_to admin_user_path(current_user)
  end
  
  private
  
    def user_params
      params.require(:admin_user).permit(:id, :name, :email, :password, :password_confirmation)
    end
    
    # Confirms an admin user.
    def admin_user
      current_user.admin?
    end
    
    def can_destroy_user
      if User.find(params[:id]).admin == 0 && current_user.admin? || current_user.id == User.find(params[:id]) 
        return true
      else
        flash[:danger] = "You are not authorized to do this"
        redirect_to admin_user_path(current_user)
      end
    end
  

    
end
