RisingGuilds::Application.routes.draw do 
   root :to =>"pages#show", :id => "home"
   
   # Static Pages Route
   match 'pages/*id' => 'pages#show'
   
   # Authentication Routes
   match "/account" => "users#show", :as => :account
   match '/logout' => 'user_sessions#destroy', :as => :logout
   match '/login' => 'user_sessions#new', :as => :login
   match '/register' => 'users#create', :as => :register
   match '/signup' => 'users#new', :as => :signup
   match '/rating' => 'rating#index', :as => :rating #:register
   match '/register/:activation_code' => 'activations#new', :as => :register
   match '/activate/:id' => 'activations#create', :as => :activate
   
   #Resources
   resources :password_resets
   resource :user_session
   resources :users do
     resources :characters
     resources :guilds
   end
       
   resources :guilds do
     resources :characters
     resources :users
     resources :raids
     resources :newsentries
     resources :events
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
   match '/guilds/:id/join/:token', :controller => 'guilds', :action => 'join'
   
   #Widget Auth Route
   match '/widget/:action/:id/:token', :controller => 'widget'
   
   #Default Route
   match ':controller/:id/:action(.:format)'
end
