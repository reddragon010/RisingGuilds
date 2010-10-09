source 'http://rubygems.org'

gem 'rails', '3.0.0.rc'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'mysql'
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

gem "hpricot"
gem "authlogic", :git => "http://github.com/odorcicd/authlogic.git", :branch => "rails3"
gem "declarative_authorization"
gem 'paperclip'
gem 'configatron'
gem "will_paginate", "~> 3.0.pre2"

gem 'test-unit'
gem 'hoe'
gem 'rubyforge'

gem 'gravtastic'
gem "breadcrumbs_on_rails"

group :development, :test do
  gem "mocha"
  gem "rspec-rails", ">= 2.0.0.beta.19"
  gem "factory_girl_rails"
  gem "email_spec"
  gem "autotest-rails"
  gem "ZenTest"
  gem "ruby_parser"
end

gem 'cover_me', '>= 1.0.0.pre2', :require => false, :group => :test

group :cucumber do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
end