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
      flash[:success] = "Welcome!"
      redirect_to admin_user_url(@user)
    else
     render 'new'
    end
    
  end
  
  private
  
    def user_params
      params.require(:admin_user).permit(:name, :email, :password, :password_confirmation)
    end
    
end
