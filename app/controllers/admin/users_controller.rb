class Admin::UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
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
    
end
