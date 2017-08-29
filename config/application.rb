require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
#Bundler.require(*Rails.groups)
Bundler.require(*Rails.groups, :assets, :application)

module Dhtv
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators do |generators|
      unless Rails.env.production? then
        generators.test_framework :rspec,
                                  view_specs: false,
                                  helper_specs: false,
                                  routing_specs: false,
                                  request_specs: false,
                                  fixtures: true
        generators.integration_tool :rspec
        generators.fixture_replacement :factory_girl, dir: 'spec/factories'
        generators.scaffold_stylesheet false
        generators.orm :active_record
        generators.template_engine :haml
        generators.stylesheets false # :scss
        generators.javascripts false # :coffee

      end

      generators.stylesheets :scss
      generators.template_engine :haml
    	
			generators.system_tests = nil
    end

  end
end
