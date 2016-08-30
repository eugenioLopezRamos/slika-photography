class Admin::UsersController < ApplicationController
  before_action :logged_in_user
  before_action :logged_in_admin_user, only: [:new, :create]
  
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

    
end
