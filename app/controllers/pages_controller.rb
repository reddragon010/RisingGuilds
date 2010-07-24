class PagesController < ApplicationController
  rescue_from ActionView::MissingTemplate, :with => :invalid_page

  def show
    render :template => current_page
  end

  protected

  def invalid_page
    render "application/404", :status => 404
  end

  def current_page
    #"pages/#{I18n.locale}/#{File.join(*params[:id]).downcase}"
    "pages/de/#{File.join(*params[:id]).downcase}"
  end  
end
