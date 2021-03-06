class NewsentriesController < ApplicationController
  filter_resource_access
  before_filter :login_required
  
  layout :choose_layout
  
  # GET /newsentries
  # GET /newsentries.xml
  def index
    if params[:guild_id]
      @newsentries = Guild.find(params[:guild_id]).newsentries
    else
      @newsentries = current_user.guilds.map{|g| g.newsentries.all}.flatten
    end
    
    respond_to do |format|
      format.xml  { render :xml => @newsentries }
    end
  end

  # GET /newsentries/1
  # GET /newsentries/1.xml
  def show
    @newsentry = Newsentry.find(params[:id])

    respond_to do |format|
      format.xml  { render :xml => @newsentry }
    end
  end

  # GET /newsentries/new
  # GET /newsentries/new.xml
  def new
    @guild = Guild.find(params[:guild_id])
    @newsentry = Newsentry.new(:guild_id => @guild.id)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @newsentry }
    end
  end

  # GET /newsentries/1/edit
  def edit
    @newsentry = Newsentry.find(params[:id])
  end

  # POST /newsentries
  # POST /newsentries.xml
  def create
    @newsentry.user_id = current_user.id
    respond_to do |format|
      if @newsentry.save
        flash[:notice] = t('newsentries.created')
        format.html { redirect_to(guild_path(@newsentry.guild)) }
        format.xml  { render :xml => @newsentry, :status => :created, :location => @newsentry }
      else
        format.html { render :action => "new", :guild_id => @newsentry.guild_id }
        format.xml  { render :xml => @newsentry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /newsentries/1
  # PUT /newsentries/1.xml
  def update
    @newsentry = Newsentry.find(params[:id])

    respond_to do |format|
      if @newsentry.update_attributes(params[:newsentry])
        flash[:notice] = t('newsentries.updated')
        format.html { redirect_to(guild_path(@newsentry.guild)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit", :guild_id => @newsentry.guild_id }
        format.xml  { render :xml => @newsentry.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /newsentries/1
  # DELETE /newsentries/1.xml
  def destroy
    @newsentry = Newsentry.find(params[:id])
    @newsentry.destroy

    respond_to do |format|
      format.html { redirect_to(guild_path(@newsentry.guild)) }
      format.xml  { head :ok }
    end
  end 
  
  protected
  
  def choose_layout
    unless params[:guild_id].nil?
      return 'guild_tabs'
    else
      return 'application'
    end
  end
end
