class GuildsController < ApplicationController
  filter_resource_access
  
  layout "guild_tabs"
  
  # GET /guilds
  # GET /guilds.xml
  def index
    if !params[:search].nil?
      @guilds = Guild.find(:all,:conditions => ['name LIKE ?',"#{params[:search]}%"])
    elsif current_user.nil? || current_user.assignments.empty?
      flash[:error] = t('guilds.not_assigned')
      redirect_to_target_or_default(root_path)
    else
      redirect_to guild_path(current_user.assignments.first.guild)
    end
  end

  # GET /guilds/1
  # GET /guilds/1.xml
  def show
    if current_user.nil? || current_user.assignments.nil?
      @guilds = [Guild.find(params[:id])]
    else
      @guilds = current_user.assignments.collect{|a| a.guild }.uniq
    end
    @online_characters = @guild.characters.find_all_by_online(true, :order => "rank") unless @guild.nil?
    @events = @guild.events.paginate :page => params[:page]
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @guild }
      format.js do    
        unless params[:page].nil?      
          render :update do |page|
            page.replace 'events', :partial => 'events'
          end
        end
      end
    end
  end

  # GET /guilds/new
  # GET /guilds/new.xml
  def new

    respond_to do |format|
      format.html { render :layout => "application"} # new.html.erb
      format.xml  { render :xml => @guild }
    end
  end

  # GET /guilds/1/edit
  def edit
   
  end

  # POST /guilds
  # POST /guilds.xml
  def create
    respond_to do |format|
      if @guild.valid_name?
        if @guild.save
          @guild.assignments << Assignment.create(:user_id => current_user.id, :role_id => 1)
          flash[:notice] = t(:created,:item => 'Guild')
          format.html { redirect_to(@guild) }
          format.xml  { render :xml => @guild, :status => :created, :location => @guild }
        else
          format.html { render :action => "new", :layout => "application"}
          format.xml  { render :xml => @guild.errors, :status => :unprocessable_entity }
        end
      else
        flash[:error] = t(:not_found, :item => 'guild')
        format.html {render :action => "new", :layout => "application"}
        format.xml  {render :xml => @guild.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /guilds/1
  # PUT /guilds/1.xml
  def update

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
      format.html { redirect_to(guilds_url) }
      format.xml  { head :ok }
    end
  end
  
  def maintain
    
  end
  
  def actualize
    @guild = Guild.find(params[:id])
    respond_to do |format|
      if @guild.remoteQueries.find_all_by_action('update_guild').empty?
        @guild.remoteQueries << RemoteQuery.create(:priority => 1, :efford => 5, :action => "update_guild")
        flash[:notice] = t(:updating, :item => 'Guild')
        format.html { redirect_to(:controller => 'guilds', :action => 'maintain', :id => @guild.id) }
        format.xml  { head :ok }
      else
        flash[:error] = t(:update_in_progress)
        format.html { redirect_to(:controller => 'guilds', :action => 'maintain', :id => @guild.id) }
        format.xml  { head :error }
      end
    end
  end
  
  def join
    @guild = Guild.find(params[:id])
    respond_to do |format|
      if params[:token] == @guild.token
        @guild.assignments << Assignment.new(:user_id => current_user.id, :role_id => Role.find_by_name("member").id)
        @guild.save
        flash[:notice] = t('guilds.joined')
        format.html { redirect_to(@guild) }
      else
        flash[:error] = t('guilds.invalid_token')
        format.html { redirect_to(@guild) }
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
  
end
