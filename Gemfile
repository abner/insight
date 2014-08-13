  source 'https://rubygems.org'


  # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
  gem 'rails', '4.1.4'


  gem 'sqlite3', :platform => :ruby
  gem "mongoid", "~> 4.0.0"

  # Use SCSS for stylesheets
  gem 'sass-rails', '~> 4.0.3'
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
  gem 'turbolinks'
  # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
  gem 'jbuilder', '~> 2.0'
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0',                              group: :doc

  # Use ActiveModel has_secure_password
  gem 'bcrypt', '~> 3.1.7'

  # Use unicorn as the app server
  gem 'puma'

  gem 'compass-rails'
  gem 'zurb-foundation'

  group :development do
    gem 'rails_layout'

  end

  group :test do
    gem 'rspec'
    #gem 'rspec-rails'
    #gem 'shoulda-matchers', require: false
    gem 'mongoid-rspec'
  end

  gem 'devise',  '~> 3.2.4'
  gem 'net-ldap',  '~> 0.3.1'

  #gem "devise_ldap_authenticatable", '~> 0.8.1'
  gem "devise_ldap_authenticatable", :git => "git://github.com/cschiewek/devise_ldap_authenticatable.git"

  gem 'foreman'

  # Use Capistrano for deployment
  # gem 'capistrano-rails', group: :development
