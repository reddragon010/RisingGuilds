authorization do
  role :admin do
    has_permission_on [:guilds, :characters], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
  end
  
  role :guildmanager do
    #has_permission_on :characters, :to => [:index, :show, :new, :create]
    #has_permission_on :characters, :to => [:edit, :update, :destroy] do
    #  if_attribute :user_id => is { user.id }
    #end
    has_permission_on :guilds, :to => [:edit, :update, :destroy, :update_guild] do
      if_attribute :managers => contains { user }
    end
  end
  
  role :user do
    #Can link chars if is a member of the guild
    has_permission_on :characters, :to => [:link] do
      if_attribute :guild => { :users => contains { user } }
    end
    #Can only show chars
    has_permission_on :characters, :to => [:index, :show]
    #Can show and create guilds
    has_permission_on :guilds, :to => [:index, :show, :new, :create,:join]
    #Can delink own chars
    has_permission_on :characters, :to => [:delink] do
      if_attribute :user_id => is { user.id }
    end
  end
  
  role :guest do
    has_permission_on [:home, :guilds, :characters], :to => [:index, :show]
  end
end