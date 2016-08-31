require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @admin = users(:michael)
    @notadmin = users(:mary)
  end
  
  
  test "user can edit his/her own profile" do
    log_in_as(@admin)
    get admin_user_path(@admin)
    assert_select 'a.profile-edit'
    get edit_admin_user_path(@admin)
    name = "A new name"
    email = "anewemail@google.com"
    password = "password-new"
    password_conf = "password-new"
    old_password = "password"

    patch admin_user_path(@admin), params: {user: {name: name,
                                                        email: email,
                                                        password: password,
                                                        password_confirmation: password_conf} }
    assert_not @admin.reload.authenticate(old_password)
    assert @admin.reload.authenticate(password)
    assert_equal @admin.name, name
    assert_equal @admin.email, email
   # assert_equal @admin.password_digest, password
    assert_redirected_to admin_user_path(@admin)
  end
  
  test "user cannot edit another user's profile" do
    
  end
  
  test "admin cannot edit another user's profile" do
    
  end
  
end
