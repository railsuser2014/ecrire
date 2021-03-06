module Admin
  class ImagesController < Admin::ApplicationController
    def index
      @images = post.images
      respond_to do |format|
        format.js
      end
    end

    def create
      @image = post.images.build
      @image.file = params[:admin_image][:file]
      respond_to do |format|
        format.js do
          render 'error' unless @image.save
        end
      end
    end

    def update
      @image = Admin::Image.find(params[:id])
      @image.update_attributes(image_params)
    end

    def destroy
      @image = Admin::Image.find(params[:id])
      @image.destroy
    end

    protected

    def post
      @post ||= Admin::Post.find(params[:post_id])
    end

    def image_params
      params.require(:admin_image).permit(:favorite)
    end

  end
end
