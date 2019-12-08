Rails.application.routes.draw do
  get "charts/index"
  get "home/index"
  root :to => 'charts#index'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #

  resources :charts
  get 'charts/list_products/:filter/:id' => 'charts#list_products', :as => :list_products
end
