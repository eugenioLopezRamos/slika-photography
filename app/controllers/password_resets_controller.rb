class Admin::PasswordResetsController < ApplicationController
  def new
  end

  def edit
  end

  def create
  	@user = User.find_by(email: params[:admin_password_reset][:email].downcase)
  	if @user
	  	@user.create_reset_digest
	  	@user.send_password_reset_email
	  	flash[:info] = "We have sent you an email with the instructions to reset your password"
	  	redirect_to 'admin/login'
	  else
	  	flash.now[:danger] = "We couldn't find that email address"
	  	redirect_to 'admin/login'
  end
end
