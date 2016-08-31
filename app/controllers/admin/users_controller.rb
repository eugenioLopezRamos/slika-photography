class Admin::UsersController < ApplicationController
  before_action :logged_in_user
  before_action :logged_in_admin_user, only: [:new, :create]
  before_action :can_destroy_user, only: :destroy
  before_action :can_edit_user, only: :edit
  
  def index
  end
  
  def new
    @user = User.new
    @url = admin_users_path
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
      @url = admin_users_path
      render 'new' 
    end
  end
  
  def edit
    @user = User.find(params[:id])
    @url = admin_user_path(@user)
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "You have successfully edited your information"
      redirect_to admin_user_path(@user)
    else
      render 'edit'
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
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
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
    
    def can_edit_user
      if current_user.id == User.find(params[:id]).id
        return true
      else
        flash[:danger] = "You are not authorized to do this"
        redirect_to admin_user_path(current_user)
      end
    end

    
end
