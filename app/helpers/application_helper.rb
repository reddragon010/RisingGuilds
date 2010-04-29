# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def raceicon_path(char)
    "http://www.wowarmory.com/_images/icons/race/#{char.race_id}-#{char.gender_id}.gif"
  end
  
  def classicon_path(char)
    "http://www.wowarmory.com/_images/icons/class/#{char.class_id}.gif"
  end
  
  def factionicon_path(char)
    "http://www.wowarmory.com/_images/icons/faction/icon-#{char.faction_id}.gif"
  end
  
  def professionicon_path(profession)
    "http://arsenal.rising-gods.de/images/icons/professions/#{profession.key}-sm.gif"
  end
  
  def talentspecicon_path(talentspec,class_id)
    talentspec.trees[0] = 0
    spec_id = talentspec.trees.index(talentspec.trees.sort.last)
    "http://arsenal.rising-gods.de/images/icons/class/#{class_id}/talents/#{spec_id}.gif"
    #"http://eu.wowarmory.com/wow-icons/_images/43x43/#{talentspec.icon}.png"
  end
  
  def charicon_path(char)
		icon_types = {:default => 'wow-default', 70 => 'wow-70', 80 => 'wow-80', :other => 'wow'}
		
		unless char.level.nil?
		  if char.level < 70
  		  dir = icon_types[:default]
  		elsif char.level >= 80
  			dir = icon_types[80]
  		elsif char.level >= 70
  			dir = icon_types[70]
  		end
		else
		  dir = icon_types[:other]
		end
		
		"http://www.wowarmory.com/_images/portraits/" + dir + "/#{char.gender_id}-#{char.race_id}-#{char.class_id}.gif"
	end
  
  def online_text(online)
    if online
      "<span style=\"color:green\">Online</span>"
    else
      "<span style=\"color:red\">Offline</span>"
    end
  end
  
  def redirect_back_or(path)
    redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to path
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
  
  def sort_td_class_helper(param)
    if params[:sort] == param then
      'class="sortup"' 
    elsif params[:sort] == param + " DESC"
      'class="sortdown"'
    end
  end
  
  def sort_link_helper(text, param)
    key = param
    if params[:sort] == param
      key += " DESC"
    end
    
    link_to text, :sort => key
  end
  
  def progressbar(value,text)
    op =  "<div class=\"bar-container\">\n"    
    op += "<div style=\"width: #{value}%;\">#{text}</div>\n"
    op += "</div>\n"
  end
  
  def profession_progressbar(profession)
    value = profession.value.to_f / profession.max.to_f * 100
    text = profession.value.to_s + "/" + profession.max.to_s
    progressbar(value.to_s,text)
  end
  
end
