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
    @attendance.raid_id = params[:raid_id]
    
    @characters = current_user.characters
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @attendance }
    end
  end

  # GET /attendances/1/edit
  def edit
    @attendance = Attendance.find(params[:id])
    
    @characters = @attendance.character.user.characters
  end

  # POST /attendances
  # POST /attendances.xml
  def create
    unless params[:character_name].blank?
      char = Character.find_by_name(params[:character_name])
      if char.nil?
        flash[:error] = t("raids.char_not_found")
        redirect_to guild_raid_path(@attendance.raid.guild, @attendance.raid)
        return true
      else
        params[:attendance][:character_id] = char.id
      end
    end

    @attendance = Attendance.new(params[:attendance])
    
    if @attendance.raid.autoconfirm && @attendance.status == 2 && check_limits(@attendance) && check_ail(@attendance)
      @attendance.status = 3
    end

    respond_to do |format|
      unless @attendance.raid.closed? || !(@attendance.character.user.nil? || !@attendance.raid.users.include?(@attendance.character.user))
        if @attendance.save
          if params[:character_name].blank?
            format.html { render :text => t(:created, :item => 'Attendance') }
            format.xml  { render :xml => @attendance, :status => :created, :location => @attendance }
          else
            flash[:notice] = t(:created, :item => 'Attendance')
            format.html { redirect_to guild_raid_path(@attendance.raid.guild, @attendance.raid) }
          end
        else
          if params[:character_name].blank?
            format.html { render :text => @attendance.errors.full_messages.join("\n"), :status => :error }
            format.xml  { render :xml => @attendance.errors, :status => :unprocessable_entity }
          else
            flash[:error] = @attendance.errors.full_messages.join("\n")
            format.html { redirect_to guild_raid_path(@attendance.raid.guild, @attendance.raid) }
          end
        end
      else
        flash[:error] = ""
        if @attendance.raid.closed?
          flash[:error] = t("raids.closed")
        elsif @attendance.raid.users.include?(@attendance.character.user)
          flash[:error] = t("raids.already_attend")
        end
        if params[:character_name].blank?
          format.html { render :text => flash[:error], :status => :error }
        else
          format.html { redirect_to guild_raid_path(@attendance.raid.guild, @attendance.raid) }
        end
      end
    end
  end

  # PUT /attendances/1
  # PUT /attendances/1.xml
  def update
    @attendance = Attendance.find(params[:id])
    if @attendance.raid.autoconfirm && params[:attendance][:status] == "2" && check_limits(@attendance) && check_ail(@attendance)
      params[:attendance][:status] = 3
    end
    respond_to do |format|
      unless @attendance.raid.closed?
        if @attendance.update_attributes(params[:attendance])
          format.html { render :text => t(:updated,:item => 'Attendance') }
          format.xml  { head :ok }
        else
          format.html { render :text => "Error", :status => :error  }
          format.xml  { render :xml => @attendance.errors, :status => :unprocessable_entity }
        end
      else
        format.html { render :text => t("raids.closed"), :status => :error }
      end
    end
  end

  # DELETE /attendances/1
  # DELETE /attendances/1.xml
  def destroy
    @attendance = Attendance.find(params[:id])
    @attendance.destroy

    respond_to do |format|
      format.html { redirect_to(guild_raid_path(@attendance.raid.guild,@attendance.raid)) }
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
          if check_ail(@attendance)
            new_status = 3
          else
            flash[:error] = t('attendances.ail_low')
            redirect_to guild_raid_path(@raid.guild, @raid)
            return true
          end
        else
          flash[:error] = t('attendances.limit_reached')
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
    return true if raid.limit_roles.blank? && raid.limit_classes.blank?
    #check rolelimits
    unless raid.limit_roles.blank?
      role_count1 =  raid.attendances.where(:role => attendance.role, :status => 3).count
      role_count2 =  raid.limit_roles[attendance.role].to_i
    end
    t1 = raid.limit_roles.blank? || role_count2.blank? || role_count1 < role_count2
    #check classlimits
    unless raid.limit_classes.blank?
      class_count1 = raid.attendances.joins(:character).where(:status => 3).where("characters.class_id == ?",character.class_id).count
      class_name = configatron.raidplanner.class_id_names.key(attendance.character.class_id)
      class_count2 = raid.limit_classes[class_name].to_i
    end
    t2 = raid.limit_classes.blank? || class_count2.blank? || class_count1 < class_count2
    t1 && t2
  end
  
  def check_ail(attendance)
    raid = attendance.raid
    character = attendance.character
    (raid.min_ail.blank? || character.ail.blank? || character.ail >= raid.min_ail)
  end
  
end
