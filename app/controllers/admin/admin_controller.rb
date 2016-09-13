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

    	img.image.store!(img.image)# => will save
    	flash.now[:danger] = "Your file has been uploaded"
    	render 'admin/upload/upload_show'

    end

end
