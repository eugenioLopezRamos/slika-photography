require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:michael)
    @post = @user.posts.build(title:"hello", content: "lorem ipsum")
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
    @user.posts.create!(title:"hello", content: "loren ipsum")
    assert_difference 'Post.count', -@user.posts.count do
      @user.destroy
    end
  end
  
  
end
