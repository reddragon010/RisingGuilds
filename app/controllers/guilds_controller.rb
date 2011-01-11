class GuildsController < ApplicationController
  filter_resource_access
  
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Guilds", :guilds_path
  add_breadcrumb Proc.new { |c| Guild.find(c.params[:id]).name }, Proc.new { |c| "/guilds/#{c.params[:id]}" }, :if => Proc.new { |c| !c.params[:id].nil? }
  
  layout :choose_layout
  
  # GET /guilds
  # GET /guilds.xml
  def index
    if params[:commit].nil?
      @guilds = Guild.where(:verified => true).paginate(:per_page => 20, :page => params[:page], :order => 'name')
    else
      @guilds = Guild
      @guilds = @guilds.where("name LIKE ?", "%#{params[:name]}%") unless params[:name].blank?
      @guilds = @guilds.where(:realm => params[:realm]) unless params[:realm].blank?
      @guilds = @guilds.where(:faction_id => params[:faction]) unless params[:faction].blank?
      @guilds = @guilds.where(:recruit_open => params[:open_recruit]) unless params[:open_recruit].blank?
      @guilds = @guilds.where(:verified => true).paginate(:per_page => 10, :page => params[:page], :order => 'name')
    end
    respond_to do |format|
      format.html
      format.json {render :json => Guild.where("name LIKE ?", "%#{params[:term]}%").map{|g| g.name}.to_json}
    end
  end

  # GET /guilds/1
  # GET /guilds/1.xml
  def show
    
    @online_characters = @guild.characters.where(:online => true).order("rank") unless @guild.nil?
    @events = @guild.events.visible.paginate(:per_page => 10, :page => params[:page], :order => 'created_at DESC')
    if @guild.users.include?(current_user)
      @newsentries = @guild.newsentries.order("sticky DESC, updated_at DESC").limit(10)
    else
      @newsentries = @guild.newsentries.where(:public => true).order("sticky DESC, updated_at DESC").limit(10)
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @guild }
      format.json {render :json => @guild.to_json(:methods => [:online_members_count, :members_count, :logo_url, :active_chars, :active_chars_high, :ail, :acl, :activity, :growth, :classratio, :achivementpoints], :expects => [:token]), :callback => params[:callback]}
    end
  end

  # GET /guilds/new
  # GET /guilds/new.xml
  def new
    add_breadcrumb "New", ""

    respond_to do |format|
      format.html { render :layout => "application"} # new.html.erb
      format.xml  { render :xml => @guild }
    end
  end

  # GET /guilds/1/edit
  def edit
    add_breadcrumb "Edit", ""
  end

  # POST /guilds
  # POST /guilds.xml
  def create
    
    respond_to do |format|
      if @guild.save
        @guild.assignments << Assignment.create(:user_id => current_user.id, :role => 'leader')
        @guild.events << Event.create(:action => 'guild_created', :content => current_user.login)
        flash[:notice] = t(:created,:item => 'Guild')
        format.html { redirect_to(@guild) }
        format.xml  { render :xml => @guild, :status => :created, :location => @guild }
      else
        format.html { render :action => "new", :layout => "application"}
        format.xml  { render :xml => @guild.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /guilds/1
  # PUT /guilds/1.xml
  def update
    add_breadcrumb "Edit", ""    

    respond_to do |format|
      if @guild.update_attributes(params[:guild])
        flash[:notice] = t(:updated, :item => 'Guild')
        format.html { redirect_to(@guild) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @guild.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /guilds/1
  # DELETE /guilds/1.xml
  def destroy
    @guild.destroy

    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.xml  { head :ok }
    end
  end
  
  def maintain
    add_breadcrumb "Maintain", ""
  end
  
  def actualize
    @guild = Guild.find(params[:id])
    @guild.last_sync = Time.now - 1.day if @guild.last_sync.nil?
    respond_to do |format|
      if @guild.verified?
        if @guild.last_sync + 30.minutes < Time.now
          @guild.delay.sync
          @guild.update_attribute(:last_sync,Time.now)
          flash[:notice] = t(:updating, :item => 'Guild')
          format.html { redirect_to(:controller => 'guilds', :action => 'maintain', :id => @guild.id) }
          format.xml  { head :ok }
        else
          flash[:error] = t(:update_in_progress)
          format.html { redirect_to(:controller => 'guilds', :action => 'maintain', :id => @guild.id) }
          format.xml  { head :error }
        end
      else
        flash[:error] = t('guilds.not_verified')
        format.html { redirect_to(:controller => 'guilds', :action => 'maintain', :id => @guild.id) }
      end
    end
  end
  
  def join
    add_breadcrumb "Join", ""
    params[:id] = Guild.where(:name => params[:guild][:name]).first.id unless params[:guild].nil? || params[:guild][:name].nil?
    params[:token] = params[:guild][:token] unless params[:guild].nil? || params[:guild][:token].nil?
    @guild = Guild.find(params[:id])
    respond_to do |format|
      if !params[:token].nil?
        if current_user.nil?
          flash[:error] = t('have_to_be_logged_in')
          unless params[:token].nil?
            cookies[:rguilds_jg_token] = params[:token]
            cookies[:rguilds_jg_gid] = params[:id]
          end
          format.html { redirect_to(login_path) }
        else
          unless cookies[:rguilds_jg_token].nil? &&  cookies[:rguilds_jg_gid].nil?
            cookies.delete(:rguilds_jg_token)
            cookies.delete(:rguilds_jg_gid)
          end
          if @guild.verified?
            if params[:token] == @guild.token
              unless @guild.users.include?(current_user)
                @guild.assignments << Assignment.create(:user_id => current_user.id, :role => "member")
                flash[:notice] = t('guilds.joined')
                format.html { redirect_to(@guild) }
              else
                flash[:error] = t('guilds.already_joined')
                format.html { redirect_to(@guild) }
              end
            else
              flash[:error] = t('guilds.invalid_token')
              format.html { redirect_to(@guild) }
            end
          else
            flash[:error] = t('guilds.not_verified')
            format.html { redirect_to(@guild) }
          end
        end
      else
        format.html
      end 
    end
  end
  
  def reset_token
    @guild = Guild.find(params[:id])
    respond_to do |format|
      if @guild.update_attribute(:token,ActiveSupport::SecureRandom::hex(8))
        flash[:notice] = t('guilds.new_token')
        format.html { redirect_to(:controller => 'guilds', :action => 'maintain', :id => @guild.id) }
      else
        flash[:error] = t(:error)
        format.html { redirect_to(:controller => 'guilds', :action => 'maintain', :id => @guild.id) }
      end
    end
  end
  
  def verify
    @guild = Guild.find(params[:id])
    respond_to do |format|
      begin
        if true#@guild.valid_name?
          @guild.update_attribute(:verified, true)
          flash[:notice] = t('guilds.verified')
          format.html { redirect_to(:controller => 'guilds', :action => 'maintain', :id => @guild.id) }
        else
          flash[:error] = t('guilds.no_valid_name')
          format.html { redirect_to(:controller => 'guilds', :action => 'maintain', :id => @guild.id) }
        end
      rescue
        flash[:error] = t('guilds.no_arsenal_connection')
        format.html { redirect_to(:controller => 'guilds', :action => 'maintain', :id => @guild.id) }
      end
    end
  end
  
  def onlinemembers 
    @guild = Guild.find(params[:id])
    @characters = @guild.characters.where(:online => true).select('name, class_id, race_id, gender_id, level')
    json = [@guild,@characters].to_json(:methods => [:online_members_count, :members_count], :only => [:name, :realm, :online_members_count, :online_members, :class_id, :race_id, :gender_id, :level])
    render :json => json, :callback => params[:callback] 
  end
  
  protected
  
  def choose_layout
    unless params[:id].nil?
      return 'guild_tabs'
    else
      return 'application'
    end
  end
  
end
