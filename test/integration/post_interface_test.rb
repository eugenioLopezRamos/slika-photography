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
    assert_select 'div.user-name-text'
    assert_select 'a.post-delete'
    
    assert_difference 'Post.count', -1 do
      delete admin_post_path(@notadminpost)
   end
  end

  test "an admin user can delete his own posts " do
    log_in_as(@admin)
    get admin_user_path(@admin)
    assert_select 'div.user-name-text'
    assert_select 'a.post-delete'
    
    assert_difference 'Post.count', -1 do
      delete admin_post_path(@adminpost)
    end
  end
  
  test "a non admin should not be able to delete someone else's posts" do
    log_in_as(@notadmin)
    get admin_user_path(@notadmin)
    assert_select 'div.user-name-text'
    
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
    assert_select 'a.post-edit'
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
    assert_select 'a.post-edit'
    get edit_admin_post_path(@adminpost)
    
    title = "a new title just for admins"
    content = "a new content just for admins"
    patch admin_post_path(@adminpost), params: { post: {title: title,
                                                      content: content} }
    assert_redirected_to admin_user_path(@admin)
    @adminpost.reload
    assert_equal @adminpost.title, title #if these are equal it means the post was successfully modified.
    assert_equal @adminpost.content, content #if these are equal it means the post was successfully modified.
  end
  
  test "an user cannot edit another user's posts" do
    log_in_as(@admin)
    @original_post = @notadminpost
    
    title = "modifying this title"
    content = "modifying this content"
    
    patch admin_post_path(@notadminpost), params: { post: {title: title,
                                                          content: content} }
    @notadminpost.reload                                                      
    assert_not_equal @notadminpost.title, title # same principle as above, if these are different it means the post wasn't modified
    assert_not_equal @notadminpost.content, content # same principle as above, if these are different it means the post wasn't modified
  end
  
  test "an user should not see links to edit/delete another user's post while on another user's profile" do
    log_in_as(@admin)
    get admin_user_path(@admin)
    assert_select 'a.post-edit'
    assert_select 'a.post-delete'
    get admin_user_path(@notadmin)
    assert_select 'a.post-edit', 0
    assert_select 'a.post-delete',0
  end

  
end
