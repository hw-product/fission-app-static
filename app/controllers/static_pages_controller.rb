class StaticPagesController < ApplicationController

  before_action :validate_user!, :except => [:show]
  before_action :validate_access!, :except => [:show]

  before_action do
    if(@product)
      product, path = params[:path].to_s.split('/', 2)
      if(@product.internal_name == product)
        params[:path] = path
      end
    else
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
          unless(static_file_path(@product, path))
            @page = @product.static_pages_dataset.where(:path => path).first
            unless(@page)
              flash[:error] = 'Page not found!'
              redirect_to error_path
            else
              content_for(:title, @page.title)
            end
          end
        else
          redirect_to error_path
        end
      end
    end
  end

  def static_file_path(product, page)
    data = Rails.application.config.settings.get(:static, :pages, product, page)
    if(data)
      @data = data
      @app_name = product.name
      render 'static/display'
      true
    end
  end

    store = Rails.application.config.fission.static_pages_content
    key = [product.internal_name, path].join('/')
    if(store[key])
      @content = store[key].dup
      @content.delete(:app)
      @nav = @content.delete(:nav)
      @app_name = product.name
      render 'static/display'
      true
    end
  end


end
