RailsApp::Application.routes.draw do
  resources :attrs
  resources :import
  resources :export

  get "statistics/index"

  match 'category/:category/:name' => 'category#show'
  match 'category/:category/:name/bbs' => 'category#bbs'
  match 'category/:category/:name/page/:id' => 'category#page'

  match '/auth/:provider/callback' => 'users#index'

	resources :users do
		collection do
			get  'register',                        :action => :register
			get  'login',                           :action => :login
			put  'auth',                            :action => :auth
			put  'logout',                          :action => :logout
      get  'about_score',                     :action => :about_score
      get  'forget_password',                 :action => :forget_password
      put  'send_password_reset_mail',        :action => :send_password_reset_mail
      get  'reset_password/:id/:reset_token', :action => :show_reset_password
      put  'reset_password',                  :action => :reset_password
      get  'feedbacks/new',                   :action => :new_feedback
      post 'feedbacks/new',                   :action => :create_feedback
		end
	end

  match '/webstorage_links/adfly_shorten.:format' => 'webstorage_links#adfly_shorten'

  resources :value_set_headers do
    resources :value_set_bodies
  end

  resources :e_books do
    collection do
      get 'page/:id', :action => :page
    end
    
    resources :webstorage_links do
			collection do
				get ':id/to_link', :action=>:show_to_link
        post ':id/to_link', :action=>:to_link
			end
		end
  end

  resources :feedbacks

  get "configinfo/index"

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
  root :to => 'e_books#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
