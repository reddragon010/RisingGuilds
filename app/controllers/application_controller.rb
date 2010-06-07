# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Authentication
  
  layout :choose_layout
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  before_filter { |c| Authorization.current_user = c.current_user}
  before_filter :write_return_to
  before_filter :setup_tabs
  
  protected
  
  def setup_tabs
    @tabs = Array.new
  end
  
  def choose_layout
    case controller_name
    when "guilds"
      return "guild_tabs" if params[:guild_id] || action_name != 'index'
    when "characters"
      if params[:guild_id]
        return "guild_tabs" 
      else
        return "character_tabs"
      end
    when "raids"
      return "guild_tabs" if params[:guild_id]
    when "users"
      return "guild_tabs" if params[:guild_id]
    end
    return "application"
  end
  
  def permission_denied
    flash[:error] = "Sorry, you are not allowed to access that page."
    redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end
  
  def write_return_to
    session[:return_to] ||= request.referer
  end
end
