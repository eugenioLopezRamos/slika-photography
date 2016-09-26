require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  #Most of the tests for the admin controller are integration tests, since they require interaction between the view, the backend and S3


  test "User is correctly redirected to admin_login_path when requesting /admin/" do
    get '/admin'
    assert_redirected_to admin_login_path
    follow_redirect!
    assert_template 'admin/sessions/new'
  end

  test "User is shown the upload show page when requesting it" do
    get admin_files_path
    assert_template 'admin/files/files'

  end


end
