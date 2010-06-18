class UserSessionsController < ApplicationController
  before_filter :login_required, :only => [:destroy]
  
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = t('user_sessions.login_successful')
      redirect_to(root_url)
    else
      flash[:error] = t'(user_sessions.login_incorrect')
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = t('user_sessions.logout_successful')
    redirect_to root_url
  end
end
