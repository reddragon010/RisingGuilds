class RaidsController < ApplicationController
  filter_resource_access
  
  before_filter :setup_raidicons, :only => [:edit, :new, :create, :update]
  before_filter :setup_guild_id
  
  add_breadcrumb "Home", :root_url
  
  layout :choose_layout
  
  # GET /raids
  # GET /raids.xml
  def index
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    
    if !@guild.nil?
      add_breadcrumb @guild.name, guild_path(@guild)
      add_breadcrumb "Raids", :guild_raids_path
      if current_user.admin?
        @raids = Raid.all
      else
        @raids = current_user.guilds.collect{|g| g.raids.where("created_at > ?", Time.now - 1.month).order("start ASC")}.flatten
      end
    elsif !params[:user_id].nil?
      add_breadcrumb 'Account', :account_path
      add_breadcrumb "Raids", :user_raids_path
      @raids = current_user.guilds.collect{|g| g.raids.where("created_at > ?", Time.now - 1.month).order("start ASC")}.flatten
    else
      add_breadcrumb "Raids", :raids_path
      @raids = @guild.raids.where("created_at > ?", Time.now - 1.month).order("start ASC").all
    end

    unless @raids.empty?
      @upcoming_raids = @raids.find_all{|raid| raid.invite_start > DateTime.now} 
      @past_raids = @raids.find_all{|raid| raid.end < DateTime.now}.reverse
      @running_raids = @raids.find_all{|raid| raid.start <= DateTime.now && raid.end >= DateTime.now}
    end
    
    @newest = @raids.sort{|a,b| b.updated_at <=> a.updated_at}.first
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @raids }
    end
  end

  # GET /raids/1
  # GET /raids/1.xml
  def show
    if !params[:guild_id].nil?
      add_breadcrumb Guild.find(params[:guild_id]).name, guild_path(params[:guild_id])
      add_breadcrumb "Raids", guild_raids_path(@guild)
      add_breadcrumb @raid.title, guild_raid_path(@raid)
    else
      add_breadcrumb "Raids", raids_path
      add_breadcrumb @raid.title, raid_path(@character)
    end
    
    if @raid.attendances.nil? || current_user.characters.nil? || @raid.attendances.where(:character_id => current_user.characters.collect{|c| c.id}).all.empty?
      @attendance = Attendance.new(:raid_id => @raid.id)
    else
      @attendance = @raid.attendances.where(:character_id => current_user.characters.collect{|c| c.id}).first
    end 
    @guild = @raid.guild
    respond_to do |format|
      format.html # show.html.erb
      format.json do 
        @raid.invitation_window = Integer((@raid.start.to_f - @raid.invite_start.to_f) / 60.to_f)
        @raid.duration = Integer((@raid.end - @raid.start).to_f / 3600.to_f)
        render :json => @raid.to_json(:methods => [:invitation_window, :duration]) 
      end
    end
  end

  # GET /raids/new
  # GET /raids/new.xml
  def new
    add_breadcrumb "Raids", raids_path
    add_breadcrumb "New", new_raid_path
    
    @raid.leader = current_user.id
  	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @raid }
    end
  end

  # GET /raids/1/edit
  def edit
    if !@guild.nil?
      add_breadcrumb @guild.name, guild_path(@guild)
      add_breadcrumb "Raids", guild_raids_path(@guild)
      add_breadcrumb @raid.title, guild_raid_path(@guild,@raid)
      add_breadcrumb "Edit", edit_guild_raid_path(@guild,@raid)
    else
      add_breadcrumb "Raids", raids_path
      add_breadcrumb @raid.title, raid_path(@raid)
      add_breadcrumb "Edit", edit_raid_path(@raid)
    end
    
    if @raid.closed?
      flash[:error] = t('raids.closed')
      redirect_to guild_raids_path(@raid.guild)
      return true
    end
    
    @raid.limit_roles = {} if @raid.limit_roles.nil?
    @raid.limit_classes = {} if @raid.limit_classes.nil?
    
    @raid.invitation_window = Integer((@raid.start.to_f - @raid.invite_start.to_f) / 60.to_f)
    @raid.duration = Integer((@raid.end - @raid.start).to_f / 3600.to_f)
    
    @possible_leaders = @raid.guild.leaders + @raid.guild.officers + @raid.guild.raidleaders
    @possible_leaders.collect!{|l| [l.login,l.id]}
  end

  # POST /raids
  # POST /raids.xml
  def create
    @raid.limit_roles = params[:limit_roles].delete_if{|k,v| v.blank?}
    @raid.end = @raid.start + params[:raid][:duration].to_i.hours
    @raid.invite_start = @raid.start - params[:raid][:invitation_window].to_i.minutes
    @raid.guilds << @raid.guild
    @raid.icon = "nil.png" if @raid.icon.blank?
    respond_to do |format|
      if @raid.save
        flash[:notice] = t(:created, :item => 'Raid')
        format.html { redirect_to guild_raid_path(@raid.guild, @raid) }
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
    unless params[:raid][:invited_guild].nil?
      unless @raid.guilds.map{|g| g.name}.include?(params[:raid][:invited_guild])
        @raid.guilds << Guild.where(:name => params[:raid][:invited_guild]) 
        flash[:notice] = t('raids.guild_to_raid')        
      end
      redirect_to guild_raid_path(@raid.guild, @raid)
      return true
    end
      
    @start_time = DateTime.civil(params[:raid][:"start(1i)"].to_i,params[:raid][:"start(2i)"].to_i,params[:raid][:"start(3i)"].to_i,params[:raid][:"start(4i)"].to_i,params[:raid][:"start(5i)"].to_i)
    @end_time = @start_time + params[:raid][:duration].to_i.hours
    @invite_start_time =  @start_time - params[:raid][:invitation_window].to_i.minutes
    
    params[:raid][:"invite_start(1i)"] = @invite_start_time.year.to_s
    params[:raid][:"invite_start(2i)"] = @invite_start_time.month.to_s
    params[:raid][:"invite_start(3i)"] = @invite_start_time.day.to_s
    params[:raid][:"invite_start(4i)"] = @invite_start_time.hour.to_s
    params[:raid][:"invite_start(5i)"] = @invite_start_time.min.to_s
    
    params[:raid][:"end(1i)"] = @end_time.year.to_s
    params[:raid][:"end(2i)"] = @end_time.month.to_s
    params[:raid][:"end(3i)"] = @end_time.day.to_s
    params[:raid][:"end(4i)"] = @end_time.hour.to_s
    params[:raid][:"end(5i)"] = @end_time.min.to_s
    
    @raid.limit_roles = params[:limit_roles].delete_if{|k,v| v.blank?}
    @raid.limit_classes = params[:limit_classes].delete_if{|k,v| v.blank?}
    
    params[:raid][:icon] = "nil.png" if params[:raid][:icon].blank?
    
    respond_to do |format|
      if @raid.update_attributes(params[:raid])
        flash[:notice] = t(:updated, :item => 'Raid')
        format.html { redirect_to guild_raid_path(@raid.guild, @raid) }
        format.xml  { head :ok }
      else
        format.html { redirect_to edit_guild_raid_path(@raid.guild, @raid) }
        format.xml  { render :xml => @raid.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /raids/1
  # DELETE /raids/1.xml
  def destroy
    @guild = @raid.guild
    @raid.destroy

    respond_to do |format|
      format.html { redirect_to(guild_raids_path(@guild)) }
      format.xml  { head :ok }
    end
  end
  
  def uninvite_guild
    @guild = Guild.find(params[:uninvited_guild])
    respond_to do |format|
      unless @raid.guild == @guild
        if @raid.guilds.delete(@guild)
          flash[:notice] = t('raids.uninvited')
        end
      else
        flash[:error] = t('raids.cant_uninvite')
      end
      format.html { redirect_to guild_raid_path(@raid.guild, @raid) }
    end
  end
  
  protected
  
  def setup_raidicons
    raid_icons_files = Dir.entries(Rails.root.to_s + "/public/images/icons/raid").reject {|f| f[0,1] == "." || f == "nil.png"} 
  	@raid_icons = {}
  	raid_icons_files.each{|f| @raid_icons[f.chomp(".png")] = f}
  	@raid_icons = @raid_icons.sort
  end
  
  def setup_guild_id
    @guild = Guild.find(params[:guild_id]) unless params[:guild_id].nil?
  end
  
  def choose_layout
    unless params[:guild_id].nil?
      return 'guild_tabs'
    else
      return 'application'
    end
  end
  
end
