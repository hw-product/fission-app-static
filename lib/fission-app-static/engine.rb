module FissionApp
  module Static
    class Engine < ::Rails::Engine
    end
  end
end

class String
  # @return [String] converted HTML tagged safe
  def haml_to_html
    Haml::Engine.new(self).render.html_safe
  end
end
