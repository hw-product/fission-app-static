Rails.application.routes.draw do
  namespace :admin do
    resources :static_pages
  end
  get 'static/:product/:path', to: 'static_pages#show', :constraints => {:path => /static.*/}
  get ':path', to: 'static_pages#show', :constraints => lambda{|req|
    puts "**************"
    p req.path
    !req.path.start_with?('/assets')
  }
end
