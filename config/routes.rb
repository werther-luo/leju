SampleApp::Application.routes.draw do
  
  get "message/index"

  get "message/new"

  get "photos/new"

  get "photos/destroy"

  get "photos/create"

  get "tags/new"

  get "tags/create"

  get "tags/destroy"

  # get "activities/new"

  # get "activities/create"

  # get "activities/show"
  resources :photos
  # resources :message
  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :user_ac_relas, only: [:create, :destroy]
  resources :activities, only: [:new, :create, :destroy,:index]

  root to: 'static_pages#map'

  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy' #, via: :delete
      
  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/show_activity', to: 'static_pages#show_activity'
  match '/activities/:id', to: 'activities#show'
  match '/map', to: 'static_pages#map'
  match '/login', to: 'static_pages#login'
  match '/register', to: 'static_pages#register'
  match '/user_setting', to: 'static_pages#setting'
  match '/message/index', to: 'message#index', via: :get 
  match '/message/new', to: 'message#create', via: :post
  match '/show_all', to: 'static_pages#show_all'
  
  # match '/jiepan', to: 'static_pages#jiepan'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
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
  # match ':controller(/:action(/:id))(.:format)'
end
