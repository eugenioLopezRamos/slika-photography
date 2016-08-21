# Preview all emails at http://localhost:3000/rails/mailers/site_mailer
class SiteMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/site_mailer/client_contact
  def client_contact
    SiteMailer.client_contact
  end

  # Preview this email at http://localhost:3000/rails/mailers/site_mailer/account_activation
  def account_activation
    SiteMailer.account_activation
  end

  # Preview this email at http://localhost:3000/rails/mailers/site_mailer/password_reset
  def password_reset
    SiteMailer.password_reset
  end

end
