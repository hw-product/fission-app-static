module FissionApp
  module Static
    class Engine < ::Rails::Engine

module FissionApp
  module Configs
    class Engine < ::Rails::Engine

      config.to_prepare do |config|
      end

      # @return [Array<Fission::Data::Models::Product>]
      def fission_product
        [
          Fission::Data::Models::Product.find_by_internal_name('fission')
        ]
      end

      # @return [Hash] account navigation
      def fission_navigation(product, current_user)
        if(product.internal_name == 'fission')
          Smash.new(
            'Admin' => Smash.new(
              'Pages' => Rails.application.routes.url_helpers.admin_static_pages_path
            )
          )
        else
          Smash.new
        end
      end

    end
  end
end

class String
  # @return [String] converted HTML tagged safe
  def haml_to_html
    Haml::Engine.new(self).render.html_safe
  end
end
