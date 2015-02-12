  source 'https://rubygems.org'


  # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
  gem 'rails', '4.2.0'

  # middleware for api
  gem 'grape'

  gem 'sqlite3', :platform => :ruby

  #ORM for mongodb
  gem "mongoid", "~> 4.0.0"

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
  # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
  gem 'turbolinks', '2.3.0'
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
  gem 'zurb-foundation'

  #assets compilation
  gem 'therubyracer'
  gem 'less-rails'

  #bootstrap
  gem "twitter-bootstrap-rails"
  gem 'data-confirm-modal', :git => 'https://github.com/ifad/data-confirm-modal.git'

  group :development do
    gem 'rails_layout'
    gem 'pry-rails'
    gem 'guard-rspec', :require => false
  end

  group :test do
    # clean database before tests
    gem 'database_cleaner', "~> 1.4"

    gem 'rspec'
    gem 'rspec-rails'
    #gem 'shoulda-matchers', require: false

    gem 'mongoid-tree'

    #mongoid mathcers for rspec
    gem 'mongoid-rspec'

    gem 'rspec-collection_matchers'

    #gem "factory_girl", "~> 4.0"
    #object factory for tests
    gem 'factory_girl_rails', "~> 4.0", :require => false

    # code coverage
    gem 'simplecov', :require => false
  end

  #gem 'devise',  '~> 3.2.4'
  gem 'devise',  '~> 3.4.1'
  #devise view with internalization
  gem 'devise-i18n-views'

  #rails internalizations
  gem 'rails-i18n', '~> 4.0.0'

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

  gem 'mongoid_slug' #create slug creation for mongoid models

gem 'libv8', '3.16.14.3'

gem 'six' # authorization (same used by gitlab ce)

gem 'rack', '~> 1.6.0'
gem 'active_model_serializers' # better way to handle json serialization

#global values request based
gem 'request_store', '~> 1.1.0'

gem 'faraday'

gem 'omniauth-expressov3'
