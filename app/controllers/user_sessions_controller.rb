class UserSessionsController < ApplicationController
  before_filter :login_required, :only => [:destroy]
  
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to_target_or_default(root_url)
    else
      flash[:error] = "Login or Password incorrect!"
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_to root_url
  end
end
