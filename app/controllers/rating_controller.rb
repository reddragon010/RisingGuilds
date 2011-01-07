class RatingController < ApplicationController
  def index
    @guilds = Guild.find_all_by_verified(true).paginate :page => params[:page], :per_page => 20, :order => "rating DESC"
  end
end
