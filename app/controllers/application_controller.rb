class ApplicationController < ActionController::Base
  include Authentication
  include BreadcrumbsOnRails::ControllerMixin
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  before_filter { |c| Authorization.current_user = c.current_user}
  before_filter :write_return_to
  before_filter :setup_tabs
  before_filter :set_user_language

  def render_optional_error_file(status_code)
    case status_code 
      when :not_found
        render_error(404)
      when 500
        render_error(500)
      when 422
        render_error(422)
      else
        super
    end
  end
  
  def render_error(status_code)
    respond_to do |type| 
      type.html { render :template => "application/#{status_code}", :layout => 'application', :status => status_code } 
      type.all  { render :nothing => true, :status => 404 } 
    end
    true
  end

  protected
  def set_user_language
    I18n.locale = current_user.language if logged_in?
  end
  
  def setup_tabs
    @tabs = Array.new
  end
  
  def permission_denied
    flash[:error] = t('no_access')
    redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to root_path
  end
  
  def write_return_to
    session[:return_to] ||= request.referer
  end
end
