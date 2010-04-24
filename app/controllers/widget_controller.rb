class WidgetController < ApplicationController
  layout nil
  
  before_filter :validate_token
  
  def index
    render(:text => 'please specify an action')
  end
  
  def onlinemembers
    @guild = Guild.find(params[:id])
    #give no access of user isnt a member of the guild
    return render(:text => 'No access') unless @user.guilds.map{|g| g.id}.include?(@guild.id)
    #prevent a nil error
    @characters = Array.new
    #find all online guildmembers unless there are no members
    @characters = @guild.characters.find(:all,:conditions => {:online => true}) unless @guild.characters.nil? || @guild.characters.empty?
    
    respond_to do |format|
      format.html { render "onlinemembers.js"}
      format.xml  { render :text => @characters.to_xml}
      format.json { render :text => @characters.to_json}
    end
  end
  
  protected
  
  def validate_token
    @user = User.find_by_single_access_token(params[:token])
    return render(:text => 'Invalid API Key') if @user.nil?
  end
end
