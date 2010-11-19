class StatisticsController < ApplicationController
  
  def index
    @guild = Guild.find(params[:guild_id])
    online_events = @guild.events.where(:action => 'today_online').order('created_at')
    unless online_events.all.blank?
      @online_start = online_events.first.created_at
      @online_data = online_events.all.map{|e| e.content.to_i}
    end
    @growth_data = @guild.events.where(:action => 'weekly_members')
    @ail_data = @guild.events.where(:action => 'weekly_ail')
  end
  
end
