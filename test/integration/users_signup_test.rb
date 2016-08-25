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
  end
  
  
end
