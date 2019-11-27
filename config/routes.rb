Rails.application.routes.draw do
  get "charts/index"
  get "home/index"
  root :to => 'charts#index'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #

  resources :charts

end
