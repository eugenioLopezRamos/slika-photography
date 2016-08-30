require 'test_helper'

class PostInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @post = posts(:crabs)
  end
  
  test "an user should be able to delete its own posts" do
    log_in_as(@user)
    get admin_user_path(@user)
    
    
    assert_difference 'Post.count', -1 do
      delete admin_post_path(@post)
    end

  end
  
end
