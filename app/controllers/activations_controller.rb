class ActivationsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]

  def new
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @user.active?
  end

  def create
    @user = User.find(params[:id])

    raise Exception if @user.active?

    if @user.activate!(params)
      @user.deliver_activation_confirmation!
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
