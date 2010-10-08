class ActivationsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]

  def new
    @user = User.where(:perishable_token => params[:activation_code]).first
    if @user.nil?
      flash[:notice] = "Wrong token"
      redirect_to root_url
    elsif @user.updated_at < 2.days.ago
      @user.destroy
      flash[:notice] = "Token has been expired! Your account is deleted. Please try to register again"
      redirect_to root_url 
    end
  end

  def create
    @user = User.find(params[:id])

    raise "User already activated!" if @user.active?

    if @user.activate!(params)
      Notifier.activation_confirmation(@user).deliver
      flash[:notice] = t('activations.account_activated')
      if !cookies[:rguilds_jg_token].nil? && !cookies[:rguilds_jg_gid].nil?
        redirect_to("/guilds/#{cookies[:rguilds_jg_gid]}/join/#{cookies[:rguilds_jg_token]}")
      else
        redirect_to account_url
      end
    else
      render :action => :new
    end
  end
end
