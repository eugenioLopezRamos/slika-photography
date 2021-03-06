class Admin::AccountActivationsController < ApplicationController

	def edit
		user = User.find_by(email: params[:email])
		if user && !user.activated? && user.authenticated?(:activation, params[:id])
			user.activated
			log_in user
			flash[:success] = "Account activated!"
			redirect_to admin_user_path(user)
		else
			flash[:danger] = "Invalid activation link"
			redirect_to admin_login_path
		end

	end

end
