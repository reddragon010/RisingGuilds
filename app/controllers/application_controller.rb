# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Authentication

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  before_filter { |c| Authorization.current_user = c.current_user}
  before_filter :write_return_to
  
  
  protected
  
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
