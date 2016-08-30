require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:michael)
    @post = @user.posts.build(title: "Hello world!", content: "lorem ipsum")
  end
  
  test "post should be valid" do
    assert @post.valid?
  end
  
  test "post should have an user_id" do
    @post.user_id = nil
    assert_not @post.valid?
  end
  
  test "content should be present" do
    @post.content = "      "
    assert_not @post.valid?
  end
  
  test "order should be most recent first" do
    assert_equal posts(:most_recent), Post.by_date_desc.first #using explicit scope instead of default scope
  end
  
  test "associated posts should be destroyed when user is deleted" do
    @user.save
    @user.posts.create!(title: "hello world", content: "loren ipsum")
    assert_difference 'Post.count', -1 do
      @user.destroy
    end
  end
  
  test "an user should be able to delete its own posts" do
    @post = @user.posts.create!(title: "hello world!", content: "lorem ipsum")
    get admin_user_path(@user)
    assert_select 'div.userName'
    assert_select 'a.post-delete'
    
    assert_difference Post.count, -1 do
      delete admin_post_path(@post)
    end
    assert_redirected_to admin_user_path(@user)
    
  end
  
  
end
