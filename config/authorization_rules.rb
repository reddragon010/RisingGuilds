authorization do
  role :admin do
    has_permission_on [:guilds, :characters, :raids], :to => [:setup, :change, :view]
    has_permission_on :authorization_rules, :to => [:read]
    has_permission_on :authorization_usages, :to => [:read]
  end
  
  role :user do
    includes :guest
    
    #Can create and join guilds
    has_permission_on :guilds, :to => [:setup]
    #Can delink own chars
    has_permission_on :characters, :to => [:delink, :actualize, :generate_ail,:make_main] do
      if_attribute :user_id => is { user.id }
    end
    
    #Can edit own attendances
    has_permission_on :attendances, :to => :change do
      if_attribute :character => {:user_id => is { user.id } }
    end
    
  end
  
  role :guest do
    has_permission_on [:home, :guilds, :characters, :events], :to => [:view]
    has_permission_on :guilds, :to => :join #permission not handled by d-auth
    has_permission_on :newsentries, :to => :view do
      if_attribute :public => is { true }
    end
  end
  
  role :leader do
    includes :officer
    
    has_permission_on :guilds, :to => :destroy
  end
  
  role :officer do
    includes :raidleader
    
    #Can administrate Guilds if is a officer or leader
    has_permission_on :guilds, :to => [:edit, :update, :maintain, :reset_token, :actualize, :verify], :join_by => :or do
      if_attribute :leaders => contains { user }
      if_attribute :officers => contains { user }
    end
  end
  
  role :raidleader do
    includes :guildmember
    has_permission_on :raids, :to => :new
    has_permission_on :raids, :to => [:create,:uninvite_guild] do
      if_attribute :guild => { :raidleaders => contains { user } }
      if_attribute :guild => { :officers => contains { user } }
      if_attribute :guild => { :leaders => contains { user } }
    end
    
    #Can create/edit Raids and edit attendances if is a leader, officer or raidleader of raid's guild
    has_permission_on [:raids,:attendances], :to => [:change, :approve], :join_by => :or do
      if_attribute :guild => { :raidleaders => contains { user } }
      if_attribute :guild => { :officers => contains { user } }
      if_attribute :guild => { :leaders => contains { user } }
    end
    
    #Can edit leading Raids
    has_permission_on :raids, :to => :change do
      if_attribute :leader => is { user.id }
    end
    
    #Can change newsentries
    has_permission_on :newsentries, :to => :change, :join_by => :or do
      if_attribute :guild => { :raidleaders => contains { user } }
      if_attribute :guild => { :officers => contains { user } }
      if_attribute :guild => { :leaders => contains { user } }
      if_attribute :user_id => is { user.id }
    end
    
    has_permission_on :newsentries, :to => :new
    has_permission_on :newsentries, :to => [:create] do
      if_attribute :guild => { :raidleaders => contains { user } }
      if_attribute :guild => { :officers => contains { user } }
      if_attribute :guild => { :leaders => contains { user } }
    end
  end
  
  role :member do
    #Can attend Raids
    has_permission_on :attendances, :to => :setup
    
    #Can view Raids of the own Guilds
    has_permission_on :raids, :to => :view, :join_by => :or do
      if_attribute :guild => { :users => contains{ user } }
      if_attribute :guilds => { :users => contains{ user } }
    end
    
    #Can link chars if is a member of the guild
    has_permission_on :characters, :to => [:link], :join_by => :and  do
      if_attribute :guild => { :users => contains { user } }
      if_attribute :user_id => is_not { user.id }
    end
    
    has_permission_on :newsentries, :to => :view, :join_by => :or do
      if_attribute :public => is { true }
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