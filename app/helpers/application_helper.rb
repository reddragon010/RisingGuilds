module ApplicationHelper 
  
  #Wow specific helpers
  def raceicon_path(char)
    "http://www.wowarmory.com/_images/icons/race/#{char.race_id}-#{char.gender_id}.gif"
  end
  
  def classicon_path(char)
    "http://www.wowarmory.com/_images/icons/class/#{char.class_id}.gif"
  end
  
  def factionicon_path(char)
    "http://www.wowarmory.com/_images/icons/faction/icon-#{char.faction_id}.gif"
  end
  
  def professionicon(profession)
    image_tag("icons/professions/#{profession.key}.png", {:size => "18x18", :title => t("professions.p#{profession.id}")})
  end
  
  def talentspecicon(talentspec)
    if talentspec.icon.blank?
      image_tag("icons/talentspecs/inv_misc_questionmark.png", {:size => "18x18"})
    else
      image_tag("icons/talentspecs/#{talentspec.icon}.png",{:size => "18x18",:title => talentspec.prim})
    end
    #"http://eu.wowarmory.com/wow-icons/_images/43x43/#{talentspec.icon}.png"
  end
  
  def roleicon(role)
    image_tag("icons/roles/#{role.downcase}.png",{:size => "18x18",:title => role})
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
  
  #Online-Text helper
  def online_text(online)
    if online
      raw("<span style=\"color:green\">Yes</span>")
    else
      raw("<span style=\"color:red\">No</span>")
    end
  end
  
  #Authlogic redirect_back helper
  def redirect_back_or(path)
    redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to path
  end
  
  #Truncate helper
  def smart_truncate(s, opts = {})
    opts = {:words => 12}.merge(opts)
    if opts[:sentences]
      return s.split(/\./)[0, opts[:sentences]].map{|s| s.strip}.join('. ') + '.'
    end
    a = s.split(/\s/) # or /[ ]+/ to only split on spaces
    n = opts[:words]
    a[0...n].join(' ') + (a.size > n ? '...' : '')
  end
  
  #Tablesort helper
  def sort_td_class_helper(param, addclasses=nil)
    classes = []
    classes << addclasses unless addclasses.nil?
    if params[:sort] == param then
      classes << 'sortup' 
    elsif params[:sort] == param + " DESC"
      classes << 'sortdown'
    end
    "class=\"#{classes.join(' ')}\""
  end
  
  def sort_link_helper(text, param)
    key = param
    if params[:sort] == param
      key += " DESC"
    end
    
    #really dirty hack !!
    unless params[:user_id].nil? 
      link_to text, "/users/#{params[:user_id]}/characters?sort=#{key}"
    else 
      link_to text, :sort => key
    end
  end
  
  #Progreessbar helper
  def progressbar(value,text)
    op =  "<div class=\"bar-container\">\n"    
    op += "<div style=\"width: #{value}%;\">#{text}</div>\n"
    op += "</div>\n"
    raw(op)
  end
  
  def profession_progressbar(profession)
    value = profession.value.to_f / profession.max.to_f * 100
    text = profession.value.to_s + "/" + profession.max.to_s
    progressbar(value.to_s,text)
  end
  
  #tooltip helper
  def tooltip(id,style=nil,&block)
    content = capture(&block)
    concat render(:partial => "shared/tooltip", :locals => {:id => id, :style => style, :text => content, :remote => true})
  end
  
  #tnb helper
  def tnb
    render(:partial => "topnavbar/layout")
  end
  
  #caching
  def caching_path(params,timestamp)
    cache_path = ""
    if !params[:guild_id].blank?
  		cache_path += "guilds/#{params[:guild_id]}/"
    elsif !params[:user_id].blank?
  		cache_path += "users/#{params[:user_id]}/"
  	end
  	cache_path += "#{params[:controller]}/#{params[:action]}"
  	cache_path += "?sort=#{params[:sort]}" unless params[:sort].blank? 
  	cache_path += "-#{@newest.updated_at.to_i}"
  end
end
