class StaticPagesController < ApplicationController

  before_action :validate_user!, :except => [:show, :deliver_asset]
  before_action :validate_access!, :except => [:show, :deliver_asset]

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
    data = Rails.application.config.settings.get(:static, :pages, product.internal_name, page)
    if(data)
      @data = data
      @app_name = product.name
      render 'static/display'
      true
    end
  end

  def deliver_asset
    item = "#{params[:path]}.#{params[:format]}"
    file = Rails.application.config.settings.fetch(:static, :asset_paths, []).map do |root|
      path = File.join(root, item)
      path if File.exists?(path)
    end.compact.first
    if(file)
      send_file file, :inline => true
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
