require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:michael)
    @post = @user.posts.build(content: "lorem ipsum")
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
  
  
  
end
