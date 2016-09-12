require 'test_helper'


class SiteMailerTest < ActionMailer::TestCase

  test "new_contact_email" do
    mail = SiteMailer.new_contact_email("Pedro", "from@example.com","Client contact", "Hi")
    assert_equal "You have been contacted", mail.subject
    assert_equal ["eugenionlopez@gmail.com"], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token
    mail = SiteMailer.account_activation(user)
    assert_equal "Invitation to Leonardo Antonio PhotoArt", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end

  test "password_reset" do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = SiteMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.reset_token, mail.body.encoded
    assert_match CGI.escape(user.email), mail.body.encoded
  end

end
