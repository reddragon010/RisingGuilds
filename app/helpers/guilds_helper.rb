module GuildsHelper
  def get_recruit_icon(guild,itemname)
    status = ''
    status = '_off' unless guild.send("recruit_#{itemname}")
    return image_tag("icons/recruit/#{itemname}#{status}.png", :alt => itemname, :size => "25x25", :id => "recruit_#{itemname}")
  end
end
