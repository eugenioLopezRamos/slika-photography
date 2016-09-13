class Admin::AdminController < ApplicationController

  require 'image.rb'

    def login
        redirect_to '/admin/login'
    end

    def upload_show
    	render 'admin/upload/upload_show'
    end

    def upload_save

    	img = Image.new
    	img.image = (params[:image][:image])
    	if img.image.size > 5.megabytes
    		flash.now[:danger] = "Max file size is 5 megabytes, please use another file"
    		render 'admin/upload/upload_show'
    	else
	    	img.image.store!(img.image)# => will save the file
	    	flash.now[:info] = "Your file has been uploaded"
	    	render 'admin/upload/upload_show'
    	end
    end

    private 

    def image_size
    	if img.size > 5.megabytes
    		errors.add(:image, "should be less than 5MB")
    	end
    end

end
