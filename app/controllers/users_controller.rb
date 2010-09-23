class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create]
  before_filter :setup_guild_id
  layout :choose_layout
  
  def index
    @users = User.all
    
    params[:sort] = 'login' if params[:sort].nil?
    
    @guild = Guild.find(params[:guild_id]) unless params[:guild_id].nil?
    
    
    unless @guild.nil? then
      if @guild.users.include?(current_user) then
        @users = @guild.users.order(params[:sort])
      else
        flash[:error] = t('no_access')
        redirect_to_target_or_default(root_path)
        return true
      end
    else
      @users = User.order(params[:sort])
    end
   
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @characters }
    end
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new
    
    if @user.signup!(params)
      @user.deliver_activation_instructions!
      flash[:notice] = t("account.created")
      redirect_to root_url
    else
      render :action => :new
    end
  end

  def show
    if @guild.nil?
      @user = @current_user
    else
      @user = User.find(params[:id])
    end
  end

  def edit
    @user = @current_user
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = t("updated", :item => 'users')
      redirect_to account_url
    else
      render :action => :edit
    end
  end
  
  def characters
    @user = @current_user
    @characters = @user.characters
  end
  
  def kick
    if params[:guild_id].nil?
      flash[:error] = t('users.no_guild')
      redirect_to root_url
    end
    @user = User.find(params[:id])
    @guild = Guild.find(params[:guild_id])
    if @user.kickable_by?(current_user,@guild)
      @guild.assignments.where(:user_id => @user.id).each {|a| a.destroy}
      flash[:notice] = t('users.kicked')
    else
      flash[:error] = t('users.not_enought_rights',:a => 'kick')
    end
    redirect_to guild_users_path(@guild)
  end
  
  def promote
    if params[:guild_id].nil?
      flash[:error] = t('users.no_guild')
      redirect_to root_url
    end
    @user = User.find(params[:id])
    @guild = Guild.find(params[:guild_id])
    if @user.promoteable_by?(current_user,@guild)
      asmt = @guild.assignments.where(:user_id => @user.id)
      if asmt.role_id > 1 && asmt.update_attribute(:role_id, asmt.role_id - 1)
        flash[:notice] = t('users.promoted')
      else
        flash[:error] = t('error')
      end
    else
      flash[:error] = t('users.not_enought_rights',:a => 'promote')
    end
    redirect_to guild_users_path(@guild)
  end
  
  def demote
    if params[:guild_id].nil?
      flash[:error] = t('users.no_guild')
      redirect_to root_url
    end
    @user = User.find(params[:id])
    @guild = Guild.find(params[:guild_id])
    if @user.demoteable_by?(current_user,@guild)
      asmt = @guild.assignments.where(user_id => @user.id)
      if asmt.role_id < 4 && asmt.update_attribute(:role_id, asmt.role_id + 1)
        flash[:notice] = t('users.demoted')
      else
        flash[:error] = t('error')
      end
    else
      flash[:error] = t('users.not_enought_rights',:a => 'demote')
    end
    redirect_to guild_users_path(@guild)
  end
  
  private
  def choose_layout
    unless params[:guild_id].nil?
      return 'guild_tabs'
    else
      return 'application'
    end
  end
  
  def setup_guild_id
    @guild = Guild.find(params[:guild_id]) unless params[:guild_id].nil?
  end
  
end
