require 'test_helper'
  #Most of the tests for the admin controller are integration tests, since they require interaction between the view, the backend and S3

class AdminControllerTest < ActionDispatch::IntegrationTest

  def setup

    @user = users(:michael)

  end



  test "User is correctly redirected to admin_login_path when requesting /admin/" do
 
    get '/admin'
    assert_redirected_to admin_login_path
    follow_redirect!
    assert_template 'admin/sessions/new'
    assert_select '.alert'
  end

  test "User is correctly redirected to admin_login_path when trying to access /files when unlogged" do
    get admin_files_path
    assert_redirected_to admin_login_path
    follow_redirect!
    assert_template 'admin/sessions/new'
    assert_select '.alert'

  end


  test "User is shown the upload show page when requesting it" do

    get admin_login_path
    assert_template 'sessions/new'
    log_in_as(@user)

    get admin_files_path
    assert_template 'admin/files/files'

  end




end
