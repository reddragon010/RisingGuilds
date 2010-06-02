authorization do
  role :admin do
    has_permission_on [:guilds, :characters, :raids], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
  end
  
  role :user do
    includes :guest
    
    #Can create and join guilds
    has_permission_on :guilds, :to => [ :setup, :join]
    #Can delink own chars
    has_permission_on :characters, :to => [:delink, :actualize, :generate_ail,:make_main] do
      if_attribute :user_id => is { user.id }
    end
    #Can link chars if is a member of the guild
    has_permission_on :characters, :to => [:link], :join_by => :and  do
      if_attribute :guild => { :users => contains { user } }
      if_attribute :user_id => is_not { user.id }
    end
    #Can administrate Guilds if is a manager
    has_permission_on :guilds, :to => [:change, :actualize], :join_by => :or do
      if_attribute :managers => contains { user }
    end
    
    #Can edit Raids and attendances if is a manager of raid's guild
    has_permission_on [:attendances], :to => [:change, :approve] do
      if_attribute :guild => { :managers => contains { user } }
    end
    
    has_permission_on [:raids], :to => [:change, :approve_all] do
      if_attribute :guild => { :managers => contains { user } }
    end
    
    #Can edit own attendances
    has_permission_on :attendances, :to => :change do
      if_attribute :character => {:user_id => is { user.id } }
    end
    
    #Can edit own Raids
    has_permission_on :raids, :to => :change do
      if_attribute :leader => is { user.id }
    end
    
  end
  
  role :guest do
    has_permission_on [:home, :guilds, :characters, :events], :to => [:view]
  end
  
  role :guildmanager do
    includes :guildmember
    #Can create Raids
    has_permission_on :raids, :to => :setup
  end
  
  role :guildmember do
    #Can attend Raids
    has_permission_on :attendances, :to => :setup
    #Can view Raids of the own Guilds
    has_permission_on :raids, :to => :view do
      if_attribute :guild => { :users => contains{ user } }
    end
  end
  
end

privileges do
  privilege :setup do
    includes :new, :create
  end
  
  privilege :change do
    includes :edit, :update, :destroy
  end
  
  privilege :view do
    includes :index, :show
  end
end