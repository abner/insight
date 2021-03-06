# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
#require 'shoulda/matchers'

require 'factory_girl_rails'


# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

require 'simplecov'
require 'simplecov-json'
require 'simplecov-rcov'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter,
  SimpleCov::Formatter::RcovFormatter
]

SimpleCov.start 'rails'



# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.

#NOT USING ACTIVE RECORD
#ActiveRecord::Migration.maintain_test_schema!

 RSpec.configure do |config|
#   # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
#   config.fixture_path = "#{::Rails.root}/spec/fixtures"
#
#   # If you're not using ActiveRecord, or you'd prefer not to run each of your
#   # examples within a transaction, remove the following line or assign false
#   # instead of true.
#   config.use_transactional_fixtures = true
#
#   # RSpec Rails can automatically mix in different behaviours to your tests
#   # based on their file location, for example enabling you to call `get` and
#   # `post` in specs under `spec/controllers`.
#   #
#   # You can disable this behaviour by removing the line below, and instead
#   # explicitly tag your specs with their type, e.g.:
#   #
#   #     RSpec.describe UsersController, :type => :controller do
#   #       # ...
#   #     end
#   #
#   # The different available types are documented in the features, such as in
#   # https://relishapp.com/rspec/rspec-rails/docs
   config.infer_spec_type_from_file_location!
 end

 require 'capybara/rspec'
 require 'capybara/poltergeist'
 require 'capybara-screenshot/rspec'


 # Capybara.register_driver :poltergeist_debug do |app|
 #   Capybara::Poltergeist::Driver.new(app, :inspector => true)
 # end
 #Capybara.javascript_driver = :poltergeist_debug
 # Capybara::Screenshot.class_eval do
 #   register_driver(:poltergeist_debug) do |driver, path|
 #     driver.render(path, :full => true)
 #   end
 # end
 Capybara.register_driver :poltergeist do |app|
   options = {
     window_size: [1440,900],
     inspector: false,
     #debug: true,
     phantomjs: Phantomjs.path,
     phantomjs_options: ['--ignore-ssl-errors=yes']#['--load-images=no', '--ignore-ssl-errors=yes']

   }
   Capybara::Poltergeist::Driver.new(app, options)
 end

 Capybara.javascript_driver = :poltergeist
 #Capybara.javascript_driver = :selenium


 Capybara.app_host = 'http://localhost:3000'
 Capybara.server_port = 3000
 #Capybara.save_and_open_page_path = 'tmp/'
 Capybara.asset_host = "http://localhost:3000"
