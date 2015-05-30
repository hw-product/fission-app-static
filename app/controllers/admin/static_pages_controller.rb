class Admin::StaticPagesController < ApplicationController

  before_action do
    if(params[:product_id])
      @product = Product.find_by_id(params[:product_id])
      @pages = @product.static_pages_dataset
    else
      @pages = StaticPage.dataset
    end
    @pages = @pages.order(:title)
    @page = @pages.where(:id => params[:id]).first
  end

  def index
    respond_to do |format|
      format.js do
        flash[:error] = 'Unsupported request!'
        javascript_redirect_to admin_static_pages_path
      end
      format.html do
        unless(@product)
          @pages = Hash[
            Product.dataset.order(:name).all.map do |product|
              [product, product.static_pages]
            end
          ]
        else
          @pages = @pages.all.group_by do |page|
            page.product
          end
        end
      end
    end
  end

  def show
    respond_to do |format|
      format.js do
        flash[:error] = 'Unsupported request!'
        javascript_redirect_to admin_static_pages_path
      end
      format.html do
        unless(@page)
          flash[:error] = 'Failed to locate requested page!'
          redirect_to admin_static_pages_path
        end
      end
    end
  end

  def new
    respond_to do |format|
      format.js do
        flash[:error] = 'Unsupported request!'
        javascript_redirect_to admin_static_pages_path
      end
      format.html do
        @products = Product.all
      end
    end
  end

  def create
    respond_to do |format|
      format.js do
        flash[:error] = 'Unsupported request!'
        javascript_redirect_to admin_static_pages_path
      end
      format.html do
        args = Hash[
          params.find_all do |k,v|
            k.to_s.start_with?('page_')
          end.map do |k,v|
            [k.sub('page_', ''), v]
          end
        ].with_indifferent_access
        @product = Product.find_by_id(args.delete(:product_id))
        if(@product)
          begin
            @page = @product.add_static_page(args)
            flash[:success] = "Page created! (#{@product.name}: #{@page.path})"
          rescue => e
            puts "ERROR!!!: #{e}"
            flash[:error] = "Failed to create path: #{e}"
          end
        end
        redirect_to admin_static_pages_path
      end
    end
  end

  def edit
    respond_to do |format|
      format.js do
        flash[:error] = 'Unsupported request!'
        javascript_redirect_to admin_static_pages_path
      end
      format.html do
        unless(@page)
          flash[:error] = "Failed to find requested page (#{params[:id]})"
          redirect_to admin_static_pages_path
        end
        @products = Product.all
      end
    end
  end

  def update
    respond_to do |format|
      format.js do
        flash[:error] = 'Unsupported request!'
        javascript_redirect_to admin_static_pages_path
      end
      format.html do
        if(@page)
          args = Hash[
            params.find_all do |k,v|
              k.to_s.start_with?('page_')
            end.map do |k,v|
              [k.sub('page_', ''), v]
            end
          ].with_indifferent_access
          begin
            @page.update(args)
            @page.save
            flash[:success] = "Page updated! (#{@product.name}: #{@page.path})"
          rescue => e
            flash[:error] = "Failed to create path: #{e}"
          end
        else
          flash[:error] = 'Failed to find requested page!'
        end
        redirect_to admin_static_pages_path
      end
    end
  end

  def destroy
    begin
      if(@page.destroy)
        flash[:success] = "Page has been deleted (#{@page.path})"
      else
        flash[:error] = "Failed to delete page (#{@page.path})"
      end
    rescue => e
      flash[:error] = "Failed to delete page (#{@page.path}): #{e}"
    end
    respond_to do |format|
      format.js do
        javascript_redirect_to admin_static_pages_path
      end
      format.html do
        redirect_to admin_static_pages_path
      end
    end
  end

end
