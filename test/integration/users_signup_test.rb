require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  test "valid creation info" do
    get new_admin_user_path
    assert_difference 'User.count', 1 do
      post admin_users_path, params: { admin_user: {name: "Example User",
                                              email: "user@example.com",
                                              password: "password",
                                              password_confirmation: "password"} }
      end
      follow_redirect!
      assert_template 'users/show'
      assert is_logged_in?
  end
  
  test "invalid creation info" do
    get new_admin_user_path
    assert_no_difference 'User.count' do
     post admin_users_path, params:  {admin_user: {name: "Example User",
                                                   email: "asdx,kj@alll.s",
                                                   password: "short",
                                                   password_confirmation: "shwrt"} }
    
    end
    assert_select "div#error_explanation"
  end
  
end
