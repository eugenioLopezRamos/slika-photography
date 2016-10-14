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

  test "valid post should be correctly saved when submitted" do 
    get admin_login_path
    post admin_login_path, params: { session: { email: @notadmin.email, password: "password" } }

    get new_admin_post_path
    title = "title for post"
    content = "content for post"

    assert_difference 'Post.count', 1 do
      post admin_posts_path, params: {post: {title: title, content: content}}
    end

    title_to_slug = ActionController::Base.helpers.strip_tags(Post.last.title).downcase.parameterize

    assert_equal Post.last.title, title
    assert_equal Post.last.content, content
    assert_equal Post.last.slug, title_to_slug

    #test that duplicate slugs are invalid

    title = "title-for%post"
    posts_count = Post.count

    assert_raises(Exception) {post admin_posts_path, params: {post: 
                                                                  {title: title, content: content}
                                                                  } }

    assert_equal Post.count, posts_count

  end


  test "img tag src's not found on the S3 bucket are kept the same" do 
    get admin_login_path
    post admin_login_path, params: { session: { email: @notadmin.email, password: "password" } }

    get new_admin_post_path
    title = "title for post"
    content = "content for post <img src='www.fakeaddress.com/random-address/here/nothere.jpg' />"

    assert_difference 'Post.count', 1 do
      post admin_posts_path, params: {post: {title: title, content: content}}
    end

    assert_equal Post.last.content, content


  end


  test "img tag src's found on the S3 bucket are modified by adding the attributes data-route, data-file, data-sizes" do
    
    get admin_login_path
    post admin_login_path, params: { session: { email: @notadmin.email, password: "password" } }

    get new_admin_post_path
    title = "title for post"
    content = "content for post <img src='/images/post-test/original-TestImage1.jpg' /><img src='/images/post-test/original-TestImage2.jpg' />"

    assert_difference 'Post.count', 1 do
      post admin_posts_path, params: {post: {title: title, content: content}}
    end

    Post.last.reload
    assert_not_equal Post.last.content, content
    
    #these are assigned just for tests
    sizes = assigns(:all_img_data_sizes)
    routes = assigns(:all_img_data_route)
    files = assigns(:all_img_data_file)

    #extract the img with nokogiri
    first_img = Nokogiri.HTML(Post.last.content).css('img')[0]
    second_img = Nokogiri.HTML(Post.last.content).css('img')[1]

    #each imgs corresponding sizes
    first_img_sizes = sizes[0]
    second_img_sizes = sizes[1]

    #each imgs corresponding route
    first_img_route = routes[0]
    second_img_route = routes[1]
    #each imgs corresponding file
    first_img_file = files[0]
    second_img_file = files[1]

    #check that ["data-sizes"] is correctly assigned.

    assert_equal first_img["data-sizes"], first_img_sizes 
    assert_equal second_img["data-sizes"], second_img_sizes
    
    #check that ["data-route"] is correctly assigned
    assert_equal first_img["data-route"], first_img_route
    assert_equal second_img["data-route"], second_img_route

    #check that ["data-file"] is correctly assigned

    assert_equal first_img["data-file"], first_img_file
    assert_equal second_img["data-file"], second_file_image

  end



end
