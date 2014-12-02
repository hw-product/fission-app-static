class StaticPagesController < ApplicationController

  before_action :validate_user!, :except => [:show]
  before_action :validate_user_permission!, :except => [:show]

  before_action do
    params[:product], params[:path] = params[:path].split('/', 2)
    @product = Product.find_by_internal_name(
      params.fetch(:product, 'fission')
    )
    unless(@product)
      @product = Product.find_by_internal_name('fission')
    end
  end

  def show
    respond_to do |format|
      format.js do
        flash[:error] = 'Unknown request!'
        javascript_redirect_to root_url
      end
      format.html do
        if(@product)
          key = (params[:path] || 'index').sub(@product.internal_name, '').sub(%r{^/}, '')
          @page = @product.static_pages_dataset.where(:path => key).first
          unless(@page)
            flash[:error] = 'Page not found!'
            redirect_to error_path
          else
            content_for(:title, @page.title)
          end
        else
          redirect_to error_path
        end
      end
    end
  end


end
