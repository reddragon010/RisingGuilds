class RatingController < ApplicationController
  def index
    @guilds = Guild.paginate :page => params[:page], :per_page => 20, :order => "rating"
  end

end
