class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update] 
  before_filter :require_no_user
    
  def new  
    render  
  end  
  
  def create  
    @user = User.where(email => params[:email])  
    if @user  
      Notifier.password_reset_instructions(@user).deliver  
      flash[:notice] = t('password_resets.instructions_sent')  
      redirect_to root_url  
    else  
      flash[:notice] = t('password_resets.no_user_found')  
      render :action => :new  
    end  
  end  

  def edit  
    render  
  end  
  
  def update  
    @user.password = params[:user][:password]  
    @user.password_confirmation = params[:user][:password_confirmation]  
    if @user.save  
      flash[:notice] = t(:updated, :item => 'Password')  
      redirect_to account_url  
    else  
      render :action => :edit  
    end  
  end  
  
  private  
  def load_user_using_perishable_token  
    @user = User.find_using_perishable_token(params[:id])  
    unless @user  
      flash[:notice] = t("password_resets.token_not_found")  
      redirect_to root_url  
    end  
  end
end
