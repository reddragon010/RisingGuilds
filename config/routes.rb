RisingGuilds::Application.routes.draw do |map|
   map.connect 'pages/*id', :controller => 'pages', :action => 'show'

   map.resources :newsentries
   map.resources :events
   map.resource :user_session
   map.resources :password_resets
   map.resource :account, :controller => "users"

   map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
   map.login '/login', :controller => 'user_sessions', :action => 'new'
   map.register '/register', :controller => 'users', :action => 'create'
   map.signup '/signup', :controller => 'users', :action => 'new'

   map.rating '/rating', :controller => 'rating', :action => 'index'

   map.register '/register/:activation_code', :controller => 'activations', :action => 'new'
   map.activate '/activate/:id', :controller => 'activations', :action => 'create'

   map.resources :guilds, :has_many => [:characters, :users, :raids, :newsentries]
   map.resources :characters
   map.resources :users, :has_many => [:characters, :guilds]
   map.resources :raids, :has_many => [:attendances]
   map.resources :attendances

   map.root :controller => "pages", :action => :show, :id => 'home'

   map.connect '/guilds/:id/join/:token', :controller => 'guilds', :action => 'join', :token => /.*/
   map.connect '/widget/:action/:id/:token', :controller => 'widget', :token => /.*/

   map.connect ':controller/:id/:action'
   map.connect ':controller/:id/:action.:format'
end
