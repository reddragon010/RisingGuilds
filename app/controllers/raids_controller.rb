class RaidsController < ApplicationController
  # GET /raids
  # GET /raids.xml
  def index
    @raids = Raid.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @raids }
    end
  end

  # GET /raids/1
  # GET /raids/1.xml
  def show
    @raid = Raid.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @raid }
    end
  end

  # GET /raids/new
  # GET /raids/new.xml
  def new
    @raid = Raid.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @raid }
    end
  end

  # GET /raids/1/edit
  def edit
    @raid = Raid.find(params[:id])
  end

  # POST /raids
  # POST /raids.xml
  def create
    @raid = Raid.new(params[:raid])

    respond_to do |format|
      if @raid.save
        flash[:notice] = 'Raid was successfully created.'
        format.html { redirect_to(@raid) }
        format.xml  { render :xml => @raid, :status => :created, :location => @raid }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @raid.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /raids/1
  # PUT /raids/1.xml
  def update
    @raid = Raid.find(params[:id])

    respond_to do |format|
      if @raid.update_attributes(params[:raid])
        flash[:notice] = 'Raid was successfully updated.'
        format.html { redirect_to(@raid) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @raid.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /raids/1
  # DELETE /raids/1.xml
  def destroy
    @raid = Raid.find(params[:id])
    @raid.destroy

    respond_to do |format|
      format.html { redirect_to(raids_url) }
      format.xml  { head :ok }
    end
  end
end
