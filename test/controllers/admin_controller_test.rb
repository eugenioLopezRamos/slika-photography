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
    if ENV['AWS_S3_BUCKET'].nil? || ENV['AWS_SECRET_ACCESS_KEY'].nil? || ENV['AWS_S3_REGION'].nil? || ENV['AWS_S3_ACCESS_KEY_ID'].nil?
      skip "At least one of these ENV variables is nil:\n  
      ENV['AWS_S3_BUCKET'], \n
      ENV['AWS_SECRET_ACCESS_KEY'], \n
      ENV['AWS_S3_REGION']\n
      ENV['AWS_S3_ACCESS_KEY_ID'],\n 
      Can't test S3 integration -> skipping AdminControllerTest - test 'User is shown upload sshow page when requesting it'"
      
    end
    get admin_files_path
    assert_template 'admin/files/files'

  end




end
