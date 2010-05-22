class Character < ActiveRecord::Base
  belongs_to :guild
  has_many :events
  has_many :remoteQueries
  belongs_to :user
  has_many :attendances
  
  serialize :profession1
  serialize :profession2
  serialize :talentspec1
  serialize :talentspec2
  serialize :items
  
  validates_uniqueness_of :name
  validates_presence_of :realm
  
  def netto_activity
    Integer((self.activity / ((Time.now - self.created_at) / 60 / 60)) * 100) unless self.activity.nil?
  end
  
  class TalentSpec
  	attr_reader :trees,:active,:group,:icon,:prim

  	def initialize(elem)
  		@trees = []
  		@trees[1] = elem[:treeOne].to_i
  		@trees[2] = elem[:treeTwo].to_i
  		@trees[3] = elem[:treeThree].to_i

      @active = elem[:active].nil? ? false : true
      @group  = elem[:group].to_i
      @icon   = elem[:icon]
      @prim   = elem[:prim]
  	end
  end

  class Profession
  	attr_reader :key, :name, :value, :max
  	alias_method :to_s, :name
  	alias_method :to_i, :value

  	def initialize(elem)
  		@key 		= elem[:key]
  		@name 	= elem[:name]
  		@value 	= elem[:value].to_i
  		@max 		= elem[:max].to_i
  	end
  end

  class Item
  	attr_reader :id, :icon, :level

  	def initialize(elem)
  		@id 				= elem[:id].to_i
  		@icon 	    = elem[:icon]
  	end
  	
  	def get_info(elem)
  	  @level = (elem%'itemInfo'%'item')[:level].to_i
  	end
  end
end