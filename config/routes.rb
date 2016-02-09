PageProcessor::Application.routes.draw do
  root :to => "groups#index"
  
  get "groups/index"

  # get "pages/index"

  get 'pages/:zoo_id' => 'subjects#show'
  
  get 'diaries/' => 'groups#index'
  get 'diaries/map' => 'groups#full_map'
  get 'diaries/casualties' => 'groups#casualty_map'
  get 'diaries/:zoo_id/export' => 'public#export'
  get 'diaries/:zoo_id/map' => 'groups#map'
  get 'diaries/:zoo_id/csv' => 'public#csv'
  get 'diaries/:zoo_id(/:page)' => 'groups#show', defaults: { page: 1 }
  
  get 'places/' => 'groups#place_map'
  
  get 'public/' => 'public#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   get 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   get 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # get ':controller(/:action(/:id))(.:format)'
end
