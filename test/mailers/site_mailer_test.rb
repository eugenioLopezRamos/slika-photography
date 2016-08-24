require 'test_helper'

class SiteMailerTest < ActionMailer::TestCase
  test "new_contact_email" do
    mail = SiteMailer.new_contact_email("Pedro", "from@example.com","Client contact", "Hi")
    assert_equal "You have been contacted", mail.subject
    assert_equal ["eugenionlopez@gmail.com"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "account_activation" do
    mail = SiteMailer.account_activation
    assert_equal "Account activation", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "password_reset" do
    mail = SiteMailer.password_reset
    assert_equal "Password reset", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
