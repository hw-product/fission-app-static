class StaticPagesController < ApplicationController

  before_action :validate_user!, :except => [:display]
  before_action do
    @product = Product.find_by_internal_name(
      params.fetch(:product, 'fission')
    )
  end

  def show
    respond_to do |format|
      format.js do
        flash[:error] = 'Unknown request!'
        javascript_redirect_to root_url
      end
      format.html do
        key = (params[:path] || 'index').sub(@product.internal_name, '').sub(%r{^/}, '')
        @page = @product.static_pages_dataset.where(:path => key).first
        unless(@page)
          # @todo render raw 404
          flash[:error] = 'Page not found!'
          redirect_to root_url
        end
        content_for(:title, @page.title)
      end
    end
  end


end
