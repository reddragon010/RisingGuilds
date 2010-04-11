# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def raceicon_path(race_id,gender_id)
    "http://www.wowarmory.com/_images/icons/race/#{race_id}-#{gender_id}.gif"
  end
  
  def classicon_path(class_id)
    "http://www.wowarmory.com/_images/icons/class/#{class_id}.gif"
  end
  
  def factionicon_path(faction_id)
    "http://www.wowarmory.com/_images/icons/faction/icon-#{faction_id}.gif"
  end
  
  def online_text(online)
    if online
      "<span style=\"color:green\">Online</span>"
    else
      "<span style=\"color:red\">Offline</span>"
    end
  end
  
  def smart_truncate(s, opts = {})
    opts = {:words => 12}.merge(opts)
    if opts[:sentences]
      return s.split(/\./)[0, opts[:sentences]].map{|s| s.strip}.join('. ') + '.'
    end
    a = s.split(/\s/) # or /[ ]+/ to only split on spaces
    n = opts[:words]
    a[0...n].join(' ') + (a.size > n ? '...' : '')
  end
end
