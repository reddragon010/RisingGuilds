class CharactersController < ApplicationController
  filter_resource_access
  
  # GET /characters
  # GET /characters.xml
  def index
    params[:sort] = 'guild_id, rank' if params[:sort].nil?
    
    @guild = Guild.find(params[:guild_id]) unless params[:guild_id].nil?
    
    filter_keys = ['guild_id', 'character_id', 'user_id']
    conditions = Hash.new
    conditions.merge!(params)
    conditions.delete_if {|key,value| !filter_keys.include? key}
    
    if conditions.empty? then
      #@characters = Character.paginate(:all, :order => params[:sort], :page => params[:page])
      @characters = Character.find(:all, :order => params[:sort])
    else
      #@characters = Character.paginate(:all, :order => params[:sort], :page => params[:page], :conditions => conditions)
      @characters = Character.find(:all, :order => params[:sort], :conditions => conditions)
    end
   
    respond_to do |format|
      format.html do
        unless params[:guild_id].nil?
          render :layout => 'guild_tabs'
        else
          render
        end
      end
      format.xml  { render :xml => @characters }
    end
  end

  # GET /characters/1
  # GET /characters/1.xml
  def show
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
        flash[:notice] = 'Character was successfully created.'
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
        flash[:notice] = 'Character was successfully updated.'
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
      flash[:error] = "Character not found"
      redirect_to root_url
    elsif @character.user.nil?
        flash[:notice] = "Character is now yours" if @character.update_attribute(:user_id, current_user.id)
        redirect_to(@character) 
    else
      flash[:error] = "Character already marked! Please contact the support"
      redirect_to(@character)
    end
  end
  
  # delete character-user connection
  def delink
    @character = Character.find(params[:id])
    #error if char was not found
    if @character.nil?
      flash[:error] = "Character not found"
      redirect_to root_url
    #error if char is not marked
    elsif @character.user.nil?
      flash[:error] = "Character not marked"
      redirect_to(@character)
    else
      @guild = @character.guild
      @user = @character.user
      #delete owner from char
      @character.user = nil
      @character.save
      #cleanup guild permissions
      @guild.reload
      flash[:notice] = "Character has been demarked"
      redirect_to(@character)
    end
  end
  
  def actualize
    @character = Character.find(params[:id])
    respond_to do |format|
      if @character.remoteQueries.find_all_by_action('update_character').empty?
        @character.remoteQueries << RemoteQuery.create(:priority => 5, :efford => 5, :action => "update_character")
        flash[:notice] = 'Character will be updated soon'
        format.html { redirect_to(@character) }
        format.xml  { head :ok }
      else
        flash[:error] = 'Update is in progress. Please be patient!'
        format.html { redirect_to(@character) }
        format.xml  { head :error }
      end
    end
  end
  
  def generate_ail
    @character = Character.find(params[:id])
    respond_to do |format|
      if @character.remoteQueries.find_all_by_action('update_character_ail').empty?
        @character.remoteQueries << RemoteQuery.create(:priority => 5, :efford => 10, :action => "update_character_ail")
        flash[:notice] = 'Character\'s AIL will be updated soon'
        format.html { redirect_to(@character) }
        format.xml  { head :ok }
      else
        flash[:error] = 'Update is in progress. Please be patient!'
        format.html { redirect_to(@character) }
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
        format.html { redirect_to_target_or_default(character_path(@character)) }
        format.xml  { head :ok }
      else
        flash[:error] = 'error - please contact the support'
        format.html { redirect_to_target_or_default(character_path(@character)) }
        format.xml  { head :error }
      end
    end
  end
  
  protected
  def guildrank_to_role(rank)
    case rank
    when 0
      role = Role.find_by_name("guildleader")
    when 1
      role = Role.find_by_name("guildofficer")
    else
      role = Role.find_by_name("guildmember")
    end
    return role
  end
end
