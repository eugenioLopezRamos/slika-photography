require 'test_helper'

class StaticControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get '/home'
    assert_response :success
  end

  test "URLs should redirect to lowercase when they aren't lowercase" do
  	get '/pEoPlE'
  	assert_redirected_to '/people'
  end

  test "not found should redirect to 404" do
  	get '/asgagasgags'
  	assert_redirected_to '/404'
  end

  test "redirect to lowercase url in /id's too" do
  	get '/bLoG/A-NEW-FANTaSTIC-POST'
  	assert_redirected_to '/blog/a-new-fantastic-post'
  end

end
