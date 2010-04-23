authorization do
  role :admin do
    has_permission_on [:guilds, :characters], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
  end
  
  role :guildmanager do
    #has_permission_on :characters, :to => [:index, :show, :new, :create]
    #has_permission_on :characters, :to => [:edit, :update, :destroy] do
    #  if_attribute :user_id => is { user.id }
    #end
  end
  
  role :user do
    #Can administrate Guilds if is a manager, officer or leader
    has_permission_on :guilds, :to => [:edit, :update, :destroy, :update_guild], :join_by => :or do
      if_attribute :managers => contains { user }
      if_attribute :leaders => contains { user }
      if_attribute :officers => contains { user }
    end
    #Can link chars if is a member of the guild
    has_permission_on :characters, :to => [:link] do
      if_attribute :guild => { :users => contains { user } }
    end
    #Can only view chars
    has_permission_on :characters, :to => [:index, :show]
    #Can view and create guilds
    has_permission_on :guilds, :to => [:index, :show, :new, :create, :join]
    #Can delink own chars
    has_permission_on :characters, :to => [:delink] do
      if_attribute :user_id => is { user.id }
    end
  end
  
  role :guest do
    has_permission_on [:home, :guilds, :characters], :to => [:index, :show]
  end
end