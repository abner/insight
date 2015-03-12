source 'https://rubygems.org'

#ruby ENV['CUSTOM_RUBY_VERSION'] || '2.2.0'
ruby '2.2.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'



# middleware for api
gem 'grape'

gem 'sqlite3', :platform => :ruby

#ORM for mongodb
gem "mongoid", "~> 4.0.0"
gem 'mongoid-tree'
gem 'mongoid_paranoia'
gem 'mongoid-slug' #create slug creation for mongoid models

# Use SCSS for stylesheets
gem 'sass-rails'#, '~> 4.0.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
platforms :jruby do
  gem 'therubyrhino'
  # Use jdbcsqlite3 as the database for Active Record
  gem 'activerecord-jdbcsqlite3-adapter'
end

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'nprogress-rails'
#gem 'jquery-turbolinks'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',  group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
gem 'puma'
#gem 'thin'

gem 'compass-rails'

#select2 autocomplete
gem "select2-rails"

#foundation css framework
#gem 'zurb-foundation'

#assets compilation
gem 'therubyracer'
gem 'less-rails'

#bootstrap
gem "twitter-bootstrap-rails"

#gem 'data-confirm-modal', :git => 'https://github.com/ifad/data-confirm-modal.git'

#gem 'noty-rails'

group :development do
  gem 'rails_layout'
  gem 'pry-rails'
  gem 'guard-rspec', :require => false
  #gem 'web-console', '~> 2.0'
  gem "better_errors"
  gem 'binding_of_caller'

  gem 'spring'
  gem 'spring-commands-rspec'
  gem "spring-commands-cucumber"

  gem 'railroady'
end

group :development, :test, :ci do
  gem 'debugger', :platforms => :mri_19
  gem 'byebug', :platforms => [:mri_20, :ruby_21, :ruby_22]
  gem 'rspec-rails'
end

#errbit / airbrake
gem 'airbrake'


group :test, :ci do
  # clean database before tests
  gem 'database_cleaner', "~> 1.4"

  gem 'cucumber-rails', :require => false

  gem 'rspec'

  #gem 'shoulda-matchers', require: false

  #mongoid mathcers for rspec
  gem 'mongoid-rspec'

  gem 'rspec-collection_matchers'

  #gem "factory_girl", "~> 4.0"
  #object factory for tests
  gem 'factory_girl_rails', "~> 4.0", :require => false

  # code coverage
  gem 'simplecov', :require => false
  gem 'simplecov-json', :require => false
  gem 'simplecov-rcov', :require => false
  
  gem 'fuubar'

  gem 'launchy' # this lets us call save_and_open_page to see what's on a page for debugging capybara tests
  gem 'capybara'
  gem 'capybara-screenshot'#, github: 'parndt/capybara-screenshot', branch: 'fix-rspec-3-0-0-deprecation'
  gem 'show_me_the_cookies'
  #gem 'rspec-instafail'
  #gem 'shoulda-matchers'
  gem 'poltergeist'
  gem 'selenium-webdriver', '>=2.45.0'

  #gem 'capybara-select2', github: 'goodwill/capybara-select2'
end

#gem 'devise',  '~> 3.2.4'
gem 'devise',  '~> 3.4.1'
#devise view with internalization
gem 'devise-i18n-views'

#rails internalizations
gem 'rails-i18n', '~> 4.0.0'
gem "i18n-js", ">= 3.0.0.rc8"  #i18n for javascripts

gem 'net-ldap',  '~> 0.3.1'

#gem "devise_ldap_authenticatable", '~> 0.8.1'
#using master from github => some issue related with rails 4 compatibility found
gem "devise_ldap_authenticatable", :git => "https://github.com/cschiewek/devise_ldap_authenticatable.git"

gem 'foreman' #process execution
gem 'foreman-export-initd' # export app foreman process as initd script

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

#group :assets do

gem 'jquery-datatables-rails', git: 'https://github.com/rweng/jquery-datatables-rails.git'
gem 'jquery-ui-rails'
#end

gem 'will_paginate' # pagination
gem "will_paginate_mongoid" # adapter to willpaginate for mongoid models

gem 'rack-cors',  require: 'rack/cors' #middleware to handle cross-domain requests



gem 'libv8', '3.16.14.3'

gem 'six' # authorization (same used by gitlab ce)

gem 'rack', '~> 1.6.0'
gem 'active_model_serializers' # better way to handle json serialization

#global values request based
gem 'request_store', '~> 1.1.0'

gem 'faraday'

gem 'omniauth-expressov3'
gem 'recursive-open-struct'


#Forms for Bootstrap
#https://github.com/bootstrap-ruby/rails-bootstrap-forms
gem 'bootstrap_form'

gem 'mongoid_rails_migrations', '~> 1.1.0'


gem "cocoon"
