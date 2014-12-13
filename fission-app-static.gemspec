$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'fission-app-static/version'
Gem::Specification.new do |s|
  s.name = 'fission-app-static'
  s.version = FissionApp::Static::VERSION.version
  s.summary = 'Fission App Static Pages'
  s.author = 'Heavywater'
  s.email = 'fission@hw-ops.com'
  s.homepage = 'http://github.com/heavywater/fission-app-static'
  s.description = 'Fission application static pages'
  s.require_path = 'lib'
  s.files = Dir['{app,lib,config,data}/**/**/*'] + %w(fission-app-static.gemspec CHANGELOG.md)
  s.add_dependency 'fission-app'
  s.add_dependency 'kramdown-rails'
end
