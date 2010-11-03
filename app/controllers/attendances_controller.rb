class AttendancesController < ApplicationController
  filter_resource_access
  
  # GET /attendances
  # GET /attendances.xml
  def index
    @attendances = Attendance.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @attendances }
    end
  end

  # GET /attendances/1
  # GET /attendances/1.xml
  def show
    @attendance = Attendance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @attendance }
    end
  end

  # GET /attendances/new
  # GET /attendances/new.xml
  def new
    @attendance = Attendance.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @attendance }
    end
  end

  # GET /attendances/1/edit
  def edit
    @attendance = Attendance.find(params[:id])
  end

  # POST /attendances
  # POST /attendances.xml
  def create
    @attendance = Attendance.new(params[:attendance])
    if @attendance.raid.autoconfirm && @attendance.status == 2 && check_limits(@attendance)
      @attendance.status = 3
    end
    respond_to do |format|
      unless @attendance.raid.closed?
      if @attendance.save
        flash[:notice] = t(:created, :item => 'Attendance')
        format.html { redirect_to guild_raid_path(@attendance.raid.guild,@attendance.raid) }
        format.xml  { render :xml => @attendance, :status => :created, :location => @attendance }
      else
        format.html { render :controller => "raid", :action => "show", :id => @attendance.raid.id }
        format.xml  { render :xml => @attendance.errors, :status => :unprocessable_entity }
      end
      else
        flash[:error] = t("raids.closed")
        format.html { redirect_to guild_raids_path(@attendance.raid.guild) }
      end
    end
  end

  # PUT /attendances/1
  # PUT /attendances/1.xml
  def update
    @attendance = Attendance.find(params[:id])
    if @attendance.raid.autoconfirm && params[:attendance][:status] == "2" && check_limits(@attendance)
      params[:attendance][:status] = 3
    end
    respond_to do |format|
      unless @attendance.raid.closed?
        if @attendance.update_attributes(params[:attendance])
          flash[:notice] = t(:updated,:item => 'Attendance')
          format.html { redirect_to guild_raid_path(@attendance.raid.guild,@attendance.raid) }
          format.xml  { head :ok }
        else
          format.html {  render :controller => "raid", :action => "show", :id => @attendance.raid.id  }
          format.xml  { render :xml => @attendance.errors, :status => :unprocessable_entity }
        end
      else
        flash[:error] = t("raids.closed")
        format.html {  redirect_to guild_raids_path(@attendance.raid.guild) }
      end
    end
  end

  # DELETE /attendances/1
  # DELETE /attendances/1.xml
  def destroy
    @attendance = Attendance.find(params[:id])
    @attendance.destroy

    respond_to do |format|
      format.html { redirect_to(attendances_url) }
      format.xml  { head :ok }
    end
  end
  
  def approve
    @attendance = Attendance.find(params[:id])
    @raid = @attendance.raid
    @character = @attendance.character
    respond_to do |format|
      if  @attendance.status == 2
        if check_limits(@attendance)
          new_status = 3
        else
          flash[:error] = "Limit is reached!"
          redirect_to guild_raid_path(@raid.guild, @raid)
          return true
        end
      else
        new_status = 2
      end
      
      if true #@attendance.role
        if @attendance.update_attribute(:status,new_status)
          flash[:notice] = t(:updated,:item => 'Attendance')
          format.html { redirect_to guild_raid_path(@raid.guild, @raid) }
          format.xml  { head :ok }
        else
          flash[:error] = t(:error)
          format.html { redirect_to guild_raid_path(@raid.guild, @raid)  }
          format.xml  { render :xml => @attendance.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
  
  protected
  
  def check_limits(attendance)
    raid = attendance.raid
    character = attendance.character
    role_count1 =  raid.attendances.where(:role => attendance.role, :status => 3).count
    role_count2 =  raid.limit_roles[attendance.role].to_i
    t1 = raid.limit_roles.nil? || role_count2.nil? || role_count1 < role_count2
    class_count1 = raid.attendances.where(:status => 3).delete_if{|a| a.character.class_id != character.class_id}.count
    class_name = configatron.raidplanner.classes[attendance.character.class_id]
    class_count2 = raid.limit_classes[class_name].to_i
    t2 = raid.limit_classes.nil? || class_count2.nil? || class_count1 < class_count2
    t1 && t2
  end
  
end
