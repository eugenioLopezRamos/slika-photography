require 'test_helper'

class StaticControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get '/home'
    assert_response :success
  end

  test "should get admin" do
    get static_admin_url
    assert_response :success
  end

end
