Rails.application.routes.draw do
  namespace :admin do
    resources :static_pages
  end
  match '*path', to: 'static_pages#show', via: :all, :constraints => lambda{|req|
    !req.path.start_with?('/assets')
  }
  root 'static_pages#show'
end
