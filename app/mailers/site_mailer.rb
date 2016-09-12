class SiteMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.site_mailer.client_contact.subject
  #


  def new_contact_email(name, email, subject, message)
    @greeting = "Hi!"
    @name = name
    @email = email   
    @subject = subject
    @cl_message = message
    mail to: "eugenionlopez@gmail.com", subject: "You have been contacted"

  end

  def account_activation(user)
    @greeting = "Hi"
    @user = user
  
    mail to: user.email, subject: 'Invitation to Leonardo Antonio PhotoArt'
  end

  def password_reset(user)
    @greeting = "Hi"
    @user = user

    mail to: @user.email, subject: 'Password reset'
  end
end
