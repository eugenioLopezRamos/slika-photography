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
      @sizes_per_file = assigns(:sizes_per_file)
      @base_file = assigns(:base_file)
    
      images = Dir.entries("#{Rails.root}/#{@public}#{@assets}#{@image_dir}/") - %w(. ..)
   
      img_count = images.select {|filename| filename.include? "original-"}.length
      img_ids = images.select {|filename| filename.include? "original-"}
      img_full_routes = img_ids

      img_full_routes.map! do |id|
        id = id.gsub!("original-", "/")
        "#{@assets}#{@image_dir}#{id}"
      end

      assert_select ".#{tab}Slide", img_count

      img_full_routes.each do |id|

        filename = String.new

        img_ids.each do |name|
          if name.include? id
            filename = name.split("/")[-1]
          end
        end
        correct_route = id.gsub(filename, '')
        
        correct_sizes = @sizes_per_file[filename]
      
        id.gsub!(/\/+/, "\\/") #Escapes the forwards slashes
        id.gsub!(/\.+/, "\\.") #Escapes any dots

        assert_select "##{id}", 1
        assert_select "##{id}" do
  
          assert_select "[data-sizes]", {:count => 1, :value => "#{correct_sizes}"}
          assert_select "[data-file]", {:count => 1, :value => "#{filename}"}
          assert_select "[data-route]", {:count => 1, :value => "#{correct_route}"}          
        end
      #  assert_select "data-sizes",   
      end
    end
  end

  test "ajax requests for tabs produce the corresponding tab" do
    #test tabs
    @tabs = ApplicationHelper::image_tabs

    @tabs.each do |tab|

      get '/tab_retriever', params: {tab: tab, id: "undefined" } # undefined is the first get when site is loaded and you nav to another tab you haven't
      #previously navegated to.

      assert_select "div.#{tab.gsub("Tab", "Slider")}", 1

    end
  end
  test "ajax requests for posts displays post content" do

    #This case will 404, which I assume is fine since we want to
    #just test that the elements are being correctly composed and passed to the browser
    get '/post_retriever', params: {slug: "any-slug"}

    assert_select "div.post", 1
    assert_select "div.post-title", 1
    assert_select "div.post-content", 1
    
  
  end



end
