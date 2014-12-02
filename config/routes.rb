Rails.application.routes.draw do
  namespace :admin do
    resources :static_pages
  end
  match '*path', to: 'static_pages#show', via: :all
  root 'static_pages#show'
end
