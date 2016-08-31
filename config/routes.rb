

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

Rails.application.routes.draw do
 # get 'sessions/new'

 # get 'users/new'

  get 'static/home'
  root 'static#home', :tab => 'homeTab'
  
  get '/home', to: 'static#show', :tab => 'homeTab'
  get '/people', to: 'static#show', :tab => 'peopleTab'
  get '/models', to: 'static#show', :tab => 'modelsTab'
  get '/urban', to: 'static#show', :tab => 'urbanTab'
  get '/events', to: 'static#show', :tab => 'eventsTab'
  get '/contact', to: 'static#show', :tab => 'contactTab'
  post '/contact', to: 'contact_mailer#create'#, :tab => 'contactTab'
  


## here I should include namespace :blog I think so i can use URL to link to posts
 


 get '/blog', to: 'static#show', :tab => 'blogTab'  
 get '/blog/:post_id', to: 'static#show', :tab => 'blogTab'
 

  
namespace :admin do
 
 resources :users #creates the REST routes for the users model
 resources :posts #creates the REST routes for the posts. These are under admin/post, and the contents will be displayed in root_path/blog for clients to see 
 get '/', to: 'admin#login'
 get '/login', to: 'sessions#new'
 post '/login', to: 'sessions#create'
 delete '/logout', to: 'sessions#destroy'


 #delete 'posts/:id', to: 'posts#destroy'

end

end
