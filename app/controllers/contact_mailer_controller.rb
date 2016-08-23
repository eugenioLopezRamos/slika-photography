class ContactMailerController < ApplicationController
    
    def create
    name = params[:clientName]
    email = params[:clientEmail]
    subject = params[:clientSubject]
    message = params[:clientMessage]
    SiteMailer.new_contact_email(name, email, subject, message).deliver_now
    end

end



