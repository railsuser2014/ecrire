class PostsController < ApplicationController
  before_action :pagination, only: :index
  protect_from_forgery except: :index

  helper_method :post

  def index
    respond_to do |format|
      format.html
      format.rss
      format.json do
        headers['Access-Control-Allow-Origin'] = '*'
      end
    end
  end

  def show
    redirect_to :root and return if post.nil?
    redirect_to :root and return unless post.published?
  end

  protected

  def post
    @post ||= Post.find_by_slug(params[:id])
  end

  def pagination
    params[:per_page] ||= 10
    params[:page] ||= 1
  end
end
