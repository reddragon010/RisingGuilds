class WidgetsController < ApplicationController
  layout :choose_layout
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Guilds", :guilds_path
  
  def index
    @guild = Guild.find(params[:guild_id])
    unless @guild.nil?
      add_breadcrumb @guild.name, guild_path(params[:guild_id])
      add_breadcrumb "Widgets", :guild_widgets_path
    end
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
