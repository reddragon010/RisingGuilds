authorization do
  role :admin do
    has_permission_on [:guilds, :characters, :raids], :to => [:setup, :change, :view]
  end
  
  role :user do
    includes :guest
    
    #Can create and join guilds
    has_permission_on :guilds, :to => [ :setup, :join]
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
  end
  
  role :leader do
    includes :officer
  end
  
  role :officer do
    includes :raidleader
    
    #Can administrate Guilds if is a officer or leader
    has_permission_on :guilds, :to => [:change, :maintain, :reset_token, :actualize], :join_by => :or do
      if_attribute :leaders => contains { user }
      if_attribute :officers => contains { user }
    end
  end
  
  role :raidleader do
    includes :guildmember
    has_permission_on :raids, :to => :new
    has_permission_on :raids, :to => :create do
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
  end
  
  role :member do
    #Can attend Raids
    has_permission_on :attendances, :to => :setup
    
    #Can view Raids of the own Guilds
    has_permission_on :raids, :to => :view do
      if_attribute :guild => { :users => contains{ user } }
    end
    
    #Can link chars if is a member of the guild
    has_permission_on :characters, :to => [:link], :join_by => :and  do
      if_attribute :guild => { :users => contains { user } }
      if_attribute :user_id => is_not { user.id }
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