require 'bogo'

# This is super hacky and needs to go away
class Smash
  def method_missing(*args, &block)
    if(args.size == 1 && !block_given? && !args.first.to_s.end_with?('='))
      self[args.first]
    else
      super
    end
  end
end

module FissionApp
  module Static
    class Engine < ::Rails::Engine

      config.to_prepare do |config|
      end

      config.after_initialize do

        [File.join(File.dirname(__FILE__), '..', '..', 'data'),
          Rails.application.config.settings.get(:static, :path),
          Rails.application.config.settings.get(:static, :paths)].flatten.compact.each do |path|
          Dir.glob(File.join(path, '**', '**', '*.{yml,json}')).each do |f_path|
            content = File.read(f_path)
            content = File.extname(f_path) == '.json' ? JSON.load(content) : YAML.load(content)
            content_path = f_path.sub(path, '').sub(File.extname(f_path), '').split(File::SEPARATOR).find_all(&:present?).map(&:to_sym)
            args = content_path + [content]
            Rails.application.config.settings.set(:static, :pages, *args)
          end
        end
        Rails.application.config.settings.set(:static, :asset_paths, [File.join(File.dirname(__FILE__), '..', '..', 'public', 'static-assets')])

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
