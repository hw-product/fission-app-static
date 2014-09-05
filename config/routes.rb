Rails.application.routes.draw do
  namespace :admin do
    resources :static_pages
  end
  get 'static/:product/:path', to: 'static_pages#show', :constraints => {:path => /.*/}
  get '(:product/):path', to: 'static_pages#show', :constraints => {:path => /(?!assets).+/} , :as => :static_page
end
