Rails.application.routes.draw do
  get 's(/:path)', to: 'static#display', :constraints => {:path => /.*/}
  get '(:path)', to: 'static#display', :constraints => {:path => /(?!assets).+/} , :as => :static_page
end
