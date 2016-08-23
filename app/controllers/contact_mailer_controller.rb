class ContactMailerController < ApplicationController
    
    def create
    name = params[:clientName]
    email = params[:clientEmail]
    subject = params[:clientSubject]
    message = params[:clientMessage]
    SiteMailer.new_contact_email(name, email, subject, message).deliver_now
    
    respond_to do |format|
    format.js { render :partial => 'layouts/jumbotron', :locals => {:tab => "contactTab"} }
    end
    end
    
    #<%= render :partial => 'users', :collection => @users, :locals => {:size => 30} %>

end



