class Admin::PasswordResetsController < ApplicationController
	before_action :get_user, only: [:edit, :update]
	before_action :valid_user, only: [:edit, :update]
	before_action :check_expiration, only: [:edit, :update] #check if reset is 'young' enough

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
	  	redirect_to  admin_login_path
	else
	  	flash[:danger] = "We couldn't find that email address"
	  	redirect_to new_admin_password_reset_path
 	end
end

def update
	if params[:user][:password].empty?
		@user.errors.add(:password, "can't be empty")
		render 'edit'
	elsif @user.update_attributes(user_params)
		log_in @user
		flash[:success] = "Password has been reset"
		redirect_to admin_user_path(@user)
	else
		render 'edit'
	end
end

private

	def user_params
		params.require(:user).permit(:password, :password_confirmation)
	end

	#before actions

	def get_user
		@user = User.find_by(email: params[:email])
	end

	def valid_user
		unless @user && @user.authenticated?(:reset, params[:id]) # && @user.activated? && @user.authenticated?(:reset, params[:id]) ) <- add left parens w/ activation
		redirect_to admin_login_path
		end
	end

	def check_expiration
		if @user.password_reset_expired?
			flash[:danger] = "Password reset has expired"
			redirect_to new_admin_password_reset_url
		end
	end


end
