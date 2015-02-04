require File.expand_path('../boot', __FILE__)

# using mongoid so active record isn't necessary
#require 'rails/all'
require "action_controller/railtie"
require "action_mailer/railtie"
#require "active_resource/railtie" # Comment this line for Rails 4.0+
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

#require 'devise/orm/mongoid'  # Ver se é realmente necessário

module FeedbackServer
  class Application < Rails::Application

    config.non_digest_named_assets = ["feedback_client_com_jquery.js","feedback_client.js", "feedback.css"]

    config.i18n.available_locales = ['pt-BR', :en]


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]

    config.paths.add Dir[Rails.root.join('app', 'api', '*.{rb,yml}')].to_s
    #config.autoload_paths << Dir[Rails.root.join('app', 'api', '*.{rb,yml}').to_s]

    #config.autoload_paths << Dir["#{config.root}/app/api"]
    config.i18n.default_locale =  :'pt-BR'

    config.assets.paths << "#{Rails}/vendor/assets/fonts"

    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        #resource '*', :headers => :any, :methods => [:get, :post, :options]
        resource '/api/*', :headers => :any, :methods => [:get, :post, :options, :put]
      end
    end
  end
end
