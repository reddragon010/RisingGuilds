class CharactersController < ApplicationController
  filter_resource_access
  
  add_breadcrumb "Home", :root_path
  
  layout :choose_layout
  
  # GET /characters
  # GET /characters.xml
  def index
    if !params[:guild_id].nil?
      add_breadcrumb "Guilds", :guilds_path
      add_breadcrumb Guild.find(params[:guild_id]).name, guild_path(params[:guild_id])
      add_breadcrumb "Members", :guild_characters_path
    elsif !params[:user_id].nil?
      add_breadcrumb "Account", account_path
      add_breadcrumb "My Characters", ""
    else
      add_breadcrumb "Characters", characters_path
      add_breadcrumb "Index", ""
    end
    
    params[:sort] = 'guild_id, rank' if params[:sort].nil?
    
    @guild = Guild.find(params[:guild_id]) unless params[:guild_id].nil?
    
    @characters = Character.order(params[:sort])
    [:guild_id, :character_id, :user_id].each do |p|
      @characters = @characters.where(p => params[p]) unless params[p].blank?
    end
    @characters = @characters.where(:online => (params[:online]=='true' ? true : false)) unless params[:online].blank?
    @characters = @characters.limit(params[:limit].to_i) unless params[:limit].blank?
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @characters.to_xml }
      format.json { render :json => @characters.to_json(:except => [:items, :created_at, :updated_at, :online, :guild_id, :user_id, :last_sync]), :callback => params[:callback] }
    end
  end

  # GET /characters/1
  # GET /characters/1.xml
  def show
    if !params[:guild_id].nil?
      add_breadcrumb "Guilds", :guilds_path
      add_breadcrumb Guild.find(params[:guild_id]).name, guild_path(params[:guild_id])
      add_breadcrumb "Members", guild_character_path(params[:guild_id])
      add_breadcrumb @character.name, guild_character_path(@character)
    elsif !params[:user_id].nil?
      add_breadcrumb "Account", account_path
      add_breadcrumb "My Characters", user_characters_path(params[:user_id])
      add_breadcrumb @character.name, user_character_path(params[:user_id],@character)
    else
      add_breadcrumb "Characters", characters_path
      add_breadcrumb @character.name, character_path(@character)
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @character }
    end
  end

  # GET /characters/new
  # GET /characters/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @character }
    end
  end

  # GET /characters/1/edit
  def edit
  end

  # POST /characters
  # POST /characters.xml
  def create
    respond_to do |format|
      if @character.save
        flash[:notice] = t(:successfull,:item => 'Character',:a => 'created')
        format.html { redirect_to(@character) }
        format.xml  { render :xml => @character, :status => :created, :location => @character }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /characters/1
  # PUT /characters/1.xml
  def update
    respond_to do |format|
      if @character.update_attributes(params[:character])
        flash[:notice] = t(:successfull,:item => 'Character',:a => 'updated')
        format.html { redirect_to(@character) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @character.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /characters/1
  # DELETE /characters/1.xml
  def destroy
    @character.destroy

    respond_to do |format|
      format.html { redirect_to(characters_url) }
      format.xml  { head :ok }
    end
  end
  
  def link
    @character = Character.find(params[:id])
    if @character.nil?
      flash[:error] = t(:not_found,:item => 'Character')
      redirect_to root_url
    elsif @character.user.nil?
        flash[:notice] = t('characters.linked') if @character.update_attribute(:user_id, current_user.id)
        redirect_to(guild_character_path(@character.guild,@character)) 
    else
      flash[:error] = t('characters.already_linked')
      redirect_to(guild_character_path(@character.guild,@character))
    end
  end
  
  # delete character-user connection
  def delink
    @character = Character.find(params[:id])
    #error if char was not found
    if @character.nil?
      flash[:error] = t(:not_found,:item => 'Character')
      redirect_to root_url
    #error if char is not marked
    elsif @character.user.nil?
      flash[:error] = t('characters.not_linked')
      redirect_to(user_path(current_user) + "/characters")
    else
      @guild = @character.guild
      @user = @character.user
      #delete owner from char
      @character.user = nil
      @character.save
      #cleanup guild permissions
      @guild.reload
      flash[:notice] = t('characters.delinked')
      redirect_to(user_path(current_user) + "/characters")
    end
  end
  
  def actualize
    @character = Character.find(params[:id]) 
    @character.last_sync = Time.now - 1.day if @character.last_sync.nil?
    respond_to do |format|
      if @character.last_sync + 30.minutes < Time.now
        @character.delay.sync
        @character.delay.sync_ail
        @character.update_attribute(:last_sync,Time.now)
        flash[:notice] = t(:updating, :item => "Character")
        format.html { redirect_to(@character) }
        format.xml  { head :ok }
      else
        flash[:error] = t(:update_in_progress)
        format.html { redirect_to(guild_character_path(@character.guild,@character)) }
        format.xml  { head :error }
      end
    end
  end
  
  def make_main
    @character = Character.find(params[:id])
    @character.user.characters.each do |char|
      char.update_attribute(:main,false)
    end
    respond_to do |format|
      if @character.update_attribute(:main,true)
        flash[:notice] =  @character.name + ' is now your new main'
        format.html { redirect_to(guild_character_path(@character.guild,@character)) }
        format.xml  { head :ok }
      else
        flash[:error] = t(:error)
        format.html { redirect_to(guild_character_path(@character.guild,@character)) }
        format.xml  { head :error }
      end
    end
  end
  
  protected
  def guildrank_to_role(rank)
    case rank
    when 0
      role = Role.where(:name => "guildleader")
    when 1
      role = Role.where(:name => "guildofficer")
    else
      role = Role.where(:name => "guildmember")
    end
    return role
  end
  
  def choose_layout
    unless params[:guild_id].nil?
        return 'guild_tabs'
    else
      return 'application'
    end
  end
end
