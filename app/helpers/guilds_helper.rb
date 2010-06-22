module GuildsHelper
  def get_recruit_icon(guild,itemname)
    status = ''
    status = '_off' unless guild.send("recruit_#{itemname}")
    return image_tag("icons/recruit/#{itemname}#{status}.png", :alt => itemname, :size => "25x25", :id => "recruit_#{itemname}")
  end
  
  def get_recruit_level_icon(guild)
    return image_tag("icons/recruit/level_#{guild.recruit_level}.png", :alt => guild.recruit_level, :size => "25x25", :id => "recruit_level") unless guild.recruit_level.nil?
  end
end
