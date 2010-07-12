class RaidsController < ApplicationController
  filter_resource_access
  
  before_filter :setup_raidicons, :only => [:edit, :new, :create, :update]
  before_filter :setup_guild_id
  
  layout :choose_layout
  
  # GET /raids
  # GET /raids.xml
  def index
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @raids = Raid.with_permissions_to(:view).find(:all, :order => "start") 

    @upcomming_raids = @raids.find_all{|raid| raid.invite_start > DateTime.now} 
    @past_raids = @raids.find_all{|raid| raid.end < DateTime.now}
    @running_raids = @raids.find_all{|raid| raid.start <= DateTime.now && raid.end >= DateTime.now}
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @raids }
    end
  end

  # GET /raids/1
  # GET /raids/1.xml
  def show
    if @raid.attendances.nil? || current_user.characters.nil? || @raid.attendances.find_all_by_character_id(current_user.characters.collect{|c| c.id}).empty?
      @attendance = Attendance.new(:raid_id => @raid.id)
    else
      @attendance = @raid.attendances.find_by_character_id(current_user.characters.collect{|c| c.id})
    end 
    @guild = @raid.guild
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @raid }
    end
  end

  # GET /raids/new
  # GET /raids/new.xml
  def new
    @raid.guild_id = @guild.id
    @raid.leader = current_user.id
  	
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @raid }
    end
  end

  # GET /raids/1/edit
  def edit
    if @raid.closed?
      flash[:error] = t('raids.closed')
      redirect_to guild_raids_path(@raid.guild)
      return true
    end
    
    @raid.invitation_window = Integer((@raid.start.to_f - @raid.invite_start.to_f) / 60.to_f)
    @raid.duration = Integer((@raid.end - @raid.start).to_f / 3600.to_f)
    
    @possible_leaders = @raid.guild.leaders + @raid.guild.officers + @raid.guild.raidleaders
    @possible_leaders.collect!{|l| [l.login,l.id]}
  end

  # POST /raids
  # POST /raids.xml
  def create
    @raid.end = @raid.start + @raid.duration.to_i.hours
    @raid.invite_start = @raid.start - @raid.invitation_window.to_i.minutes
    @raid.guilds << @raid.guild
    
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
      @raid.guilds << Guild.find_by_name(params[:raid][:invited_guild])
      flash[:notice] = t('raids.guild_to_raid')
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
    raid_icons_files = Dir.entries(RAILS_ROOT + "/public/images/icons/raid").reject {|f| f[0,1] == "." || f == "nil.png"} 
  	@raid_icons = {}
  	raid_icons_files.each{|f| @raid_icons[f.chomp(".png")] = f}
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
