Rails.application.routes.draw do
 
  get 'static/home'
  root 'static#home', :tab => 'homeTab'
  
  get '/home', to: 'static#show', :tab => 'homeTab'
  get '/people', to: 'static#show', :tab => 'peopleTab'
  get '/models', to: 'static#show', :tab => 'modelsTab'
  get '/urban', to: 'static#show', :tab => 'urbanTab'
  get '/events', to: 'static#show', :tab => 'eventsTab'
  get '/contact', to: 'static#show', :tab => 'contactTab'
  post '/contact', to: 'contact_mailer#create'#, :tab => 'contactTab'

  get '/blog', to: 'static#show', :tab => 'blogTab'#, :post_id => Post.last.id
  get '/blog/:post_id', to: 'static#show', :tab => 'blogTab'
  
  get 'post_api', to: 'static#retrieve_posts'
 

  
namespace :admin do
 
 resources :users #creates the REST routes for the users model
 resources :posts #creates the REST routes for the posts. These are under admin/post, and the contents will be displayed in root_path/blog for clients to see 
 get '/', to: 'admin#login'
 get '/login', to: 'sessions#new'
 post '/login', to: 'sessions#create'
 delete '/logout', to: 'sessions#destroy'

end

end
