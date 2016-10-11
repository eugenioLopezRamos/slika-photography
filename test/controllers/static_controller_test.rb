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

  test "redirect to lowercase url in /:id's too" do

  	get '/bLoG/A-NEW-FANTaSTIC-POST'
  	assert_redirected_to '/blog/a-new-fantastic-post'

  end

  test "each tab with slides should successfully show all images in its corresponding folder" do
    
    @tabs = ApplicationHelper::image_tabs.map {|tab| tab.gsub('Tab', '')}
  
    @tabs.each do |tab|
      get "/#{tab}"

      @public = assigns(:public_folder)
      @assets = assigns(:assets_dir)
      @image_dir = assigns(:image_dir)
    
      images = Dir.entries("#{Rails.root}/#{@public}#{@assets}#{@image_dir}/") - %w(. ..)
   
      img_count = images.select {|filename| filename.include? "original-"}.length
      img_ids = images.select {|filename| filename.include? "original-"}

      img_ids.map! do |id|
        id = id.gsub!("original-", "/")
        "#{@assets}#{@image_dir}#{id}"
      end

      assert_select ".#{tab}Slide", img_count

      img_ids.each do |id|
        id.gsub!(/\/+/, "\\/") #Escapes the forwards slashes
        id.gsub!(/\.+/, "\\.") #Escapes any dots

        assert_select "##{id}", 1  
      end
    end
  end



end
