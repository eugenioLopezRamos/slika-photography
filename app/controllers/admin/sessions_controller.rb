class Admin::SessionsController < ApplicationController

def new
end

def create
    @user = User.find_by(email: params[:session][:email].downcase) #sets user to be used 
    if @user && @user.authenticate(params[:session][:password]) #if user exists and authenticates
    log_in @user #log the user in
    params[:session][:remember_me] == "1" ? remember(@user) : forget(@user) #depending on the value of the remember me checkbox, either remember the user or forget him
    redirect_to admin_user_url(@user)  #redirect him to his profile page
    else #otherwise
        #error
        flash.now[:danger] = "Invalid email/password combination" #show a flash describing the errors
        render 'new' #send him back to the login page (which is sessions/new.html.erb)
    end
end

def destroy #destroys a session
    log_out if logged_in? #logs out an user only if he's actually logged in. Necessary to avoid bugs when the user is logged in in multiple tabs
    redirect_to '/home' #send the user to the /home portion of the site (that is, the user facing '/home' instead of the admin panel)
end


end
