class StatisticsController < ApplicationController
  layout :choose_layout
  
  def index
    @guild = Guild.find(params[:guild_id])
    online_events = @guild.events.where(:action => 'today_online').order('created_at')
    unless online_events.all.blank?
      @online_start = online_events.first.created_at
      @online_data = online_events.all.map{|e| e.content.to_i}
    end
    growth_events = @guild.events.where(:action => 'weekly_members').order('created_at')
    unless growth_events.all.blank?
      @growth_start = growth_events.first.created_at
      @growth_data = growth_events.all.map{|e| e.content.to_i}
    end
    ail_events = @guild.events.where(:action => 'weekly_ail')
    unless ail_events.all.blank?
      @ail_start = ail_events.first.created_at
      @ail_data = ail_events.all.map{|e| e.content.to_i}
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
