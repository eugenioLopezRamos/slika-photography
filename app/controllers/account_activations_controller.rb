class Admin::AccountActivationsController < ApplicationController

	def edit
		#debugger
		@user = User.find_by(email: params[:email])
		if @user && !user.activated? && @user.authenticated?(:activation, params[:id]) #params[:id] is the token.
			@user.activate
			log_in @user
			flash.now[:success] = "Account activated!"
			redirect_to admin_user_path(@user)
		else
			flash.now[:danger] = "Invalid activation link"
			redirect_to admin_login_path
		end

	end

end
