class CharactersController < ApplicationController
  filter_resource_access
  
  # GET /characters
  # GET /characters.xml
  def index
    params[:sort] = 'rank ASC' if params[:sort].nil?

    filter_keys = ['guild_id', 'character_id','token']
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
      format.html # index.html.erb
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
end
