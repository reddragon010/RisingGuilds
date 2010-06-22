# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

RACES   = {"human" => 1, "orc" => 2 , "dwarf" => 3, "nightelve" => 4, "undead" => 5, "tauren" => 6, "gnome" => 7,"troll" => 8,"bloodelve" => 10, "draenei" => 11}
CLASSES = {"warrior" => 1, "paladin" => 2, "hunter" => 3, "rogue" => 4, "priest" => 5, "dk" => 6, "shaman" => 7, "mage" => 8, "warlock" => 9, "druid" => 11} 
FACTION = {"alliance" => 0, "horde" => 1}
RAIDTYPES = {"tank" => 1, "damage" => 2, "healer" => 3}
GENDER  = {"male" => 0, "female" => 1}

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
  
  config.gem "hpricot"
  config.gem "authlogic"
  config.gem "declarative_authorization"
  config.gem 'paperclip', :source => 'http://gemcutter.org'
  config.gem 'configatron'
  config.gem 'will_paginate', :version => '~> 2.3.11', :source => 'http://gemcutter.org'
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Vienna'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  
  
  config.action_view.sanitized_allowed_tags = 'table', 'tr', 'td', 'a', 'b', 'span', 'h1', 'h2', 'h3'
end