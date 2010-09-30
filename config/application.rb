require File.expand_path('../boot', __FILE__)



require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

RACES   = {"human" => 1, "orc" => 2 , "dwarf" => 3, "nightelve" => 4, "undead" => 5, "tauren" => 6, "gnome" => 7,"troll" => 8,"bloodelve" => 10, "draenei" => 11}
CLASSES = {"warrior" => 1, "paladin" => 2, "hunter" => 3, "rogue" => 4, "priest" => 5, "dk" => 6, "shaman" => 7, "mage" => 8, "warlock" => 9, "druid" => 11} 
FACTION = {"alliance" => 0, "horde" => 1}
RAIDTYPES = {"tank" => 1, "damage" => 2, "healer" => 3}
GENDER  = {"male" => 0, "female" => 1}
LEVELS = {"10" => 10, "20" => 20, "30" => 30, "40" => 40, "50" => 50, "60" => 60, "70" => 70, "80" => 80}

require 'arsenal'

module RisingGuilds
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{Rails.root}/lib)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Vienna' 

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales' ,'*.{rb,yml}')]
    config.i18n.default_locale = :en
    
    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    config.action_view.sanitized_allowed_tags = 'table', 'tr', 'td', 'a', 'b', 'span', 'h1', 'h2', 'h3'
    
    # jquery-ujs 
    config.action_view.javascript_expansions[:defaults] = %w(jquery rails application)
  end
end
