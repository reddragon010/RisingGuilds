class UsersController < ApplicationController
  before_filter :login_required, :except => [:new, :create]
  before_filter :setup_guild_id
  layout :choose_layout
  
  def index
    @users = User.all
    
    params[:sort] = 'login' if params[:sort].nil?
    
    @guild = Guild.find(params[:guild_id]) unless params[:guild_id].nil?
    
    
    unless @guild.nil? then
      @users = @guild.users.find(:all, :order => params[:sort])
    else
      @users = User.find(:all, :order => params[:sort])
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
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
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
      flash[:notice] = "Account updated!"
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
      flash[:error] = "No guild specified!"
      redirect_to root_url
    end
    @user = User.find(params[:id])
    @guild = Guild.find(params[:guild_id])
    if current_user.guild_role_id(@guild.id) < @user.guild_role_id(@guild.id)
      @guild.assignments.find_all_by_user_id(@user.id).each {|a| a.destroy}
      flash[:notice] = "User kicked!"
    else
      flash[:error] = "you have not enought rights to kick this user"
    end
    redirect_to guild_path(@guild)
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
