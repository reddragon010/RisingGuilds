class WidgetsController < ApplicationController
  layout :choose_layout
  
  def index
    
  end
  
  protected
  
  def choose_layout
    unless params[:guild_id].nil?
      return 'guild_tabs'
    else
      return 'application'
    end
  end
end
