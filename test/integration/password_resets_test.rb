require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest


def setup
  ActionMailer::Base.deliveries.clear
  @notadmin = users(:mary)
end

  test "When the user clicks the 'forgot password' link, the password_resets/new
  template is rendered" do
  	get admin_login_path
  	assert_template 'admin/sessions/new'
  	get new_admin_password_reset_path
  	assert_template 'password_resets/new'
  	assert_select 'input#admin_password_reset_email'
  end

  test "A password reset email is not created nor sent if the entered email is unknown or invalid" do
  	get new_admin_password_reset_path

  	post admin_password_resets_path, params: { admin_password_reset: {email: ""} }

  	user = assigns(:user)
  	assert_nil user

  	assert_equal 0, ActionMailer::Base.deliveries.size

  	assert_redirected_to new_admin_password_reset_path
  	follow_redirect!
  	assert_template 'password_resets/new'
  	assert_not flash.empty?

  end

  test "The email is sent for a valid email address and the update password page is correctly displayed, includes the reset token, and correctly updates the
  user's password" do
  	#ask for password reset
  	get new_admin_password_reset_path
  	post admin_password_resets_path, 
  		params: { admin_password_reset: {email: @notadmin.email} }

  	assert_not_equal @notadmin.reset_digest, @notadmin.reload.reset_digest

  	user = assigns(:user)
  	assert_not_nil user
  	assert_not_nil user.reset_token
  	assert_not_nil user.reset_digest

  	assert_equal 1, ActionMailer::Base.deliveries.size

  	assert_redirected_to admin_login_path
  	follow_redirect!
  	assert_template 'sessions/new'
  	assert_not flash.empty?  #end up on the login page successfully/


  	#go to the password reset link with an incorrect email
  	get edit_admin_password_reset_path(user.reset_token, email: "")
  	assert_redirected_to admin_login_path

  	#go to the password reset link with the correct email
  	get edit_admin_password_reset_path(user.reset_token, email: user.email)
  	assert_template 'password_resets/edit'
  	assert_select 'input[type="hidden"][name="email"][value=?]', user.email

  	#update with an empty password
  	old_digest = user.password_digest
  	patch admin_password_reset_path(user.reset_token),
  		params: {email: user.email,
  				 user: {password: '',
  						password_confirmation: ''}}
  	assert_equal user.reload.password_digest, old_digest
  	assert_template 'admin/password_resets/edit'
  	assert_select 'div#error_explanation'

  	#update with an invalid password
  	old_digest = user.password_digest
  	patch admin_password_reset_path(user.reset_token),
  		params: {email: user.email,
  				 user: {password: 'a',
  										password_confirmation: 'a'}}
  	assert_equal user.reload.password_digest, old_digest
  	assert_template 'admin/password_resets/edit'
  	assert_select 'div#error_explanation'



  	#update the new password correctly
  	patch admin_password_reset_path(user.reset_token),
  		params: {email: user.email,
  				 user: {password: 'newpassword',
  										password_confirmation: 'newpassword'}}
  	assert_not_equal old_digest, user.reload.password_digest
  	assert is_logged_in?
  	assert_not flash.empty?
  	assert_redirected_to admin_user_path(@notadmin)

  end

  test "Password reset links become invalid two hours after creation" do
#user creates a new password reset
	get new_admin_password_reset_path
	post admin_password_resets_path, 
  		params: { admin_password_reset: {email: @notadmin.email} }

	user = assigns(:user)

	travel 3.hours do
	get edit_admin_password_reset_path(user.reset_token, email: user.email)
	assert_redirected_to new_admin_password_reset_url

	old_digest = @notadmin.password_digest

	#send a patch request while the request is invvalid
  	patch admin_password_reset_path(user.reset_token),
  		params: {email: user.email,
  				 user: {password: 'newpassword',
  						password_confirmation: 'newpassword'}}
  	assert_equal @notadmin.password_digest, old_digest
  	end


  end

end
