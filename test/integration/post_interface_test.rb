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
  
  test "an non admin user should be able to edit his/her posts" do
    log_in_as(@notadmin)
    get admin_user_path(@notadmin)
    assert_template 'users/show'
    assert_select 'a.post-edit-btn'
    get edit_admin_post_path(@notadminpost)
    
    @original_post = @notadminpost
    patch admin_post_path(@notadminpost), params: { post: {title: "a new title",
                                                      content: "a new content"} }
    assert_redirected_to admin_user_path(@notadmin)
    assert_equal @original_post, @notadminpost
  end
  
  test "admin user should be able to edit his/her own posts" do
    log_in_as(@admin)
    get admin_user_path(@admin)
    assert_template 'users/show'
    assert_select 'a.post-edit-btn'
    get edit_admin_post_path(@adminpost)
    
    @original_post = @adminpost
    patch admin_post_path(@adminpost), params: { post: {title: "a new title just for admins",
                                                      content: "a new content just for admins"} }
    assert_redirected_to admin_user_path(@admin)
    assert_equal @original_post, @adminpost
  end
  
  test "an user cannot edit another user's posts" do
    log_in_as(@admin)
    @original_post = @notadminpost
    patch admin_post_path(@notadminpost), params: {post: {title: "modifying this title",
                                                          content: "modifying this content"} }
    assert_equal @original_post, @notadminpost
  end
  
  ##add test user should not be able to see edit link for other user's posts
  
end
