class UserSessionsController < ApplicationController
  before_filter :login_required, :only => [:destroy]
  
  def new
    @user_session = UserSession.new
    @user = User.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = t('user_sessions.login_successful')
      if !cookies[:rguilds_jg_token].nil? && !cookies[:rguilds_jg_gid].nil?
        redirect_to("/guilds/#{cookies[:rguilds_jg_gid]}/join/#{cookies[:rguilds_jg_token]}")
      else
        redirect_to(root_url)
      end
      
    else
      flash[:error] = t('user_sessions.login_incorrect')
      @user_session.errors.clear
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = t('user_sessions.logout_successful')
    redirect_to root_url
  end
end
