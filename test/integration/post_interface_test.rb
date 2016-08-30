require 'test_helper'

class PostInterfaceTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @admin = users(:michael)
    @notadmin = users(:mary)
    @adminpost = posts(:crabs)
    @notadminpost = posts(:apples)
  end
  
  test "a non admin user is able to delete its own posts" do
    log_in_as(@notadmin)
    get admin_user_path(@notadmin)
    assert_select 'span.userName'
    assert_select 'a.post-delete'
    
    assert_difference 'Post.count', -1 do
      delete admin_post_path(@notadminpost)
   end
  end

  test "an admin user can delete his own posts " do
    log_in_as(@admin)
    get admin_user_path(@admin)
    assert_select 'span.userName'
    assert_select 'a.post-delete'
    
    assert_difference 'Post.count', -1 do
      delete admin_post_path(@adminpost)
    end
  end
  
  test "a non admin should not be able to delete someone else's posts" do
    log_in_as(@notadmin)
    get admin_user_path(@notadmin)
    assert_select 'span.userName'
    
    assert_no_difference 'Post.count' do
      delete admin_post_path(@adminpost)
    end
  end
  
  test "an admin should be able to delete anyone else's posts" do
    log_in_as(@admin)
    get admin_user_path(@admin)
    
    assert_difference 'Post.count', -1 do
     delete admin_post_path(@notadminpost)
    end
    

  end
  
  
  
end
