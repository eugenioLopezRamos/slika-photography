# Preview all emails at http://localhost:3000/rails/mailers/site_mailer
class SiteMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/site_mailer/client_contact
  def new_contact_email
    name = "Eugenio"
    email = "email@email.com"
    subject = "You have been contacted"
    message = "Mi mama me mima"
    SiteMailer.new_contact_email(name, email, subject, message)
  end

  # Preview this email at http://localhost:3000/rails/mailers/site_mailer/account_activation
  def account_activation
    user = User.first
    user.activation_token = User.new_token
    SiteMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/site_mailer/password_reset
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    SiteMailer.password_reset(user)
  end

end
