class Admin::AdminController < ApplicationController

  require 'image.rb'

    def login
        redirect_to '/admin/login'
    end

    def upload_show
    	render 'admin/upload/upload_show'
    end

  def upload_save
  	@img = Image.new
   	@img.image = (params[:image][:image])
    	if @img.image.size > 5.megabytes
     		flash.now[:danger] = "Max file size is 5 megabytes, please use another file"
     		render 'admin/upload/upload_show'
     	else
    		@img.key = "attempt2"
	    	@img.image.store! # => will save the file
	    	flash.now[:info] = "Your file has been uploaded! address: #{@img.image.url}"
 	    	render 'admin/upload/upload_show'
     	end
     end

end
