class ContactMailerController < ApplicationController
    
    def create
    name = ActionController::Base.helpers.sanitize params[:clientName]
    email = ActionController::Base.helpers.sanitize params[:clientEmail]
    subject = ActionController::Base.helpers.sanitize params[:clientSubject]
    message = ActionController::Base.helpers.sanitize params[:clientMessage]
    SiteMailer.new_contact_email(name, email, subject, message).deliver_now
    end

end



