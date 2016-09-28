Rails.application.routes.draw do

  root 'static#home', :tab => 'homeTab'

  get '/home', to: 'static#show', :tab => 'homeTab'
  get '/people', to: 'static#show', :tab => 'peopleTab'
  get '/models', to: 'static#show', :tab => 'modelsTab'
  get '/urban', to: 'static#show', :tab => 'urbanTab'
  get '/events', to: 'static#show', :tab => 'eventsTab'
  get '/contact', to: 'static#show', :tab => 'contactTab'
  post '/contact', to: 'contact_mailer#create'#, :tab => 'contactTab'

  #get '/blog/' => redirect("/blog/"), :slug => "#{Post.last.slug}" #, to: 'static#show', :tab => 'blogTab'#, :post_id => Post.last.id
  #need to fix this one so I don't need to have a model reference here, it causes problems when deploying on empty databases and
  #queries the post model even on unrelated routes
  get '/blog/:slug', to: 'static#show', :tab => 'blogTab'
  
  get 'post_api', to: 'static#retrieve_posts'
  get '/tab_getter', to: 'static#retrieve_tabs'



  
namespace :admin do #maybe I should move this to resources: instead of namespace but I'm not sure
 
 resources :users #creates the REST routes for the users model
 resources :posts, param: :slug#creates the REST routes for the posts. These are under admin/post, and the contents will be displayed in root_path/blog for clients to see 
 resources :account_activations, only: [:edit] #check if done
 resources :password_resets, only: [:new, :create, :edit]
 #put 'password_resets/:id/edit' => 'password_resets#update', :as => :put_password_reset
 match 'password_resets/:id/edit' => 'password_resets#update', via: [:put, :patch], :as => :password_reset

#file manager routes
 get '/files', to: 'admin#files_show'
 get 'download_file', to: 'admin#req_download_file_info' #gets messages from the download (N° of files downloaded, errors)
 post '/upload', to: 'admin#upload_file'
 post 'download_file', to: 'admin#download_file'
 delete 'delete_file', to: 'admin#delete_file'


 get '/', to: 'admin#login'
 get '/login', to: 'sessions#new'
 post '/login', to: 'sessions#create'
 delete '/logout', to: 'sessions#destroy'


end

get '/(:tab)/(:id)', to: 'static#redirect' #if the user doesnt use downcase tab urls, downcases the URL. If 
# the route doesnt exist, redirects to 404

end
