require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @admin = users(:michael)
    @notadmin = users(:mary)
    @adminpost = posts(:crabs)
    @notadminpost = posts(:apples)
  end
  
  test "user should not be able to create a post without being logged in" do
    #try to access page
    get new_admin_post_path
    assert_redirected_to admin_login_path
    follow_redirect!
    assert_template 'sessions/new'
    
    #create post with request
    assert_no_difference 'Post.count' do
      post admin_posts_path, params: {post: {title: "mytitle", content: "new content"}}
    end
  end
  
  test "user should not be able to edit a post without log in" do
    #try to access page
    get edit_admin_post_path(@adminpost)
    assert_redirected_to admin_login_path
    follow_redirect!
    assert_template 'sessions/new'
    
    #update post with requests
    title = "New title for post"
    content = "New content for this post"
    
    patch admin_post_path(@adminpost), params: {post: {title: title, content: content } }
    @adminpost.reload
    assert_not_equal @adminpost.title, title
    assert_not_equal @adminpost.content, content
    
  end
  
  test "user should be sent to login page if trying to destroy post without log in" do
    #delete post with request
    delete admin_post_path(@notadminpost)
    assert_not_equal @notadminpost.title, nil
    assert_not_equal @notadminpost.content, nil
    assert_redirected_to admin_login_path
    
  end

end
