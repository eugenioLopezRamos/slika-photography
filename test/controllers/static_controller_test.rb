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
       # debugger
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



end
