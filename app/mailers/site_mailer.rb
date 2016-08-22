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
   # debugger
    mail to: "eugenionlopez@gmail.com", subject: "You have been contacted"
    #render 'views/layouts/tabs/contactForm'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.site_mailer.account_activation.subject
  #
  def account_activation
    @greeting = "Hi"

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.site_mailer.password_reset.subject
  #
  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
