RisingGuilds::Application.routes.draw do 
   root :to =>"pages#show", :id => "home"
   
   # Static Pages Route
   match 'pages/:id' => 'pages#show'
   
   # Authentication Routes
   match '/logout' => 'user_sessions#destroy', :as => :logout
   match '/login' => 'user_sessions#new', :as => :login
   match '/register' => 'users#create', :as => :register
   match '/signup' => 'users#new', :as => :signup
   match '/rating' => 'rating#index', :as => :rating #:register
   match '/register/:activation_code' => 'activations#new', :as => :register
   match '/activate/:id' => 'activations#create', :as => :activate
   
   #Resources
   resource :account, :controller => "users"
   resources :password_resets
   resource :user_session
   resources :users do
     resources :characters
     resources :guilds
     resources :raids
   end
       
   resources :guilds do
     resources :characters
     resources :users
     resources :raids
     resources :newsentries
     resources :events
     resources :statistics
     resources :widgets
   end
   resources :characters do
     resources :events
   end
   resources :events
   resources :newsentries
   
   resources :raids do
     resources :attendances
   end
   resources :attendances
   
   #Guild Join Route
   match '/guilds/:id/join/:token' => 'guilds#join'
   
   #Default Route
   match ':controller/:id/:action(.:format)'
end
