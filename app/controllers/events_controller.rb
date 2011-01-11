class EventsController < ApplicationController
  filter_resource_access
  
  layout :choose_layout
  
  # GET /events
  # GET /events.xml
  def index
    @events = Event.visible.where(:guild_id => params[:guild_id]) unless params[:guild_id].nil?
    @events = Event.visible.where(:character_id => params[:character_id]) unless params[:character_id].nil?
    @events = @events.order("created_at DESC").paginate(:per_page => 10, :page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
      format.js
      format.json { render :json => @events.to_json(:methods => [:character_name, :text, :created_ago], :only => [:action, :content, :name, :created_at, :text, :created_ago]), :callback => params[:callback]}
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit

  end

  # POST /events
  # POST /events.xml
  def create
    respond_to do |format|
      if @event.save
        flash[:notice] = t(:created, :item => 'event')
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = t(:updated, :item => 'event')
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end
  
  def choose_layout
    unless params[:guild_id].nil?
      return 'guild_tabs'
    else
      return 'application'
    end
  end
end
