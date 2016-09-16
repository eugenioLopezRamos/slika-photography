Rails.application.routes.draw do

  root 'static#home', :tab => 'homeTab'

  get '/home', to: 'static#show', :tab => 'homeTab'
  get '/people', to: 'static#show', :tab => 'peopleTab'
  get '/models', to: 'static#show', :tab => 'modelsTab'
  get '/urban', to: 'static#show', :tab => 'urbanTab'
  get '/events', to: 'static#show', :tab => 'eventsTab'
  get '/contact', to: 'static#show', :tab => 'contactTab'
  post '/contact', to: 'contact_mailer#create'#, :tab => 'contactTab'

  get '/blog/' => redirect("/blog/"), :slug => "#{Post.last.slug}" #, to: 'static#show', :tab => 'blogTab'#, :post_id => Post.last.id
  get '/blog/:slug', to: 'static#show', :tab => 'blogTab'
  
  get 'post_api', to: 'static#retrieve_posts'
  get '/tab_getter', to: 'static#retrieve_tabs'



  
namespace :admin do #maybe I should move this to resources: instead of namespace but I'm not sure
 
 resources :users #creates the REST routes for the users model
 resources :posts, param: :slug#creates the REST routes for the posts. These are under admin/post, and the contents will be displayed in root_path/blog for clients to see 
 resources :account_activations, only: [:edit]
 resources :password_resets, only: [:new, :create, :edit]
 #put 'password_resets/:id/edit' => 'password_resets#update', :as => :put_password_reset
 match 'password_resets/:id/edit' => 'password_resets#update', via: [:put, :patch], :as => :password_reset

 get '/upload', to: 'admin#upload_show'
 post '/upload', to: 'admin#upload_save'

 get '/', to: 'admin#login'
 get '/login', to: 'sessions#new'
 post '/login', to: 'sessions#create'
 delete '/logout', to: 'sessions#destroy'

 get 'download_file', to: 'admin#download_file'
 delete 'delete_file', to: 'admin#delete_file'

end

get '/(:tab)/(:id)', to: 'static#redirect' #if the user doesnt use downcase tab urls, downcases the URL. If 
# the route doesnt exist, redirect to 404

end
