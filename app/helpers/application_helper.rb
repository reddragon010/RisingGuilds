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
  
  def tabs_content(tabs)
    if tabs.is_a? Array then
      tab_html = ""
      tabs.each do |tab|
        unless tab.empty?
          tab_html += "<li class=\"tab\">#{tab}</li>\n"
        else
          tab_html += "<li class=\"tab\" id=\"spacer\">&nbsp;</li>\n"
        end
      end
      content_for :tabs do
        tab_html
      end
    else
      return ''
    end
  end
  
end
