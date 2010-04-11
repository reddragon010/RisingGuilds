authorization do
  role :admin do
    has_permission_on [:guilds, :characters], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
  end
  
  role :user do
    #includes :guest
    has_permission_on [:guilds, :characters], :to => [:index, :show, :new, :create]
    has_permission_on :characters, :to => [:edit, :update, :destroy] do
      if_attribute :user_id => is { user.id }
    end
  end
  
  role :guest do
    has_permission_on [:home, :guilds, :characters], :to => [:index, :show]
  end
end