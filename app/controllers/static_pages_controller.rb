class StaticPagesController < ApplicationController

  before_action :validate_user!, :except => [:show]
  before_action :validate_access!, :except => [:show]

  before_action do
    product, path = params[:path].to_s.split('/', 2)
    if(product && product.present?)
      @product = Product.find_by_internal_name(product)
    end
    unless(@product)
      @product = Product.find_by_internal_name('fission')
    else
      params[:path] = path
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
          path = params[:path].present? ? params[:path] : 'index'
          @page = @product.static_pages_dataset.where(:path => path).first
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
