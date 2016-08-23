class ContactMailerController < ApplicationController
    
    def create
    name = params[:clientName]
    email = params[:clientEmail]
    subject = params[:clientSubject]
    message = params[:clientMessage]
    SiteMailer.new_contact_email(name, email, subject, message).deliver_now
    
    #respond_to do |format|
    #format.js {redirect_to '/contact'} #{ render :partial => 'layouts/jumbotron', :locals => {:tab => "homeTab"} }
    #end
    #render :js => 'alert("We have been contacted");'
    end
    
    #<%= render :partial => 'users', :collection => @users, :locals => {:size => 30} %>

end



