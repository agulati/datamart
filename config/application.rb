require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TcTrends
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += Dir["#{Rails.root}/lib"]
    config.logger = ActiveSupport::Logger.new(File.join(Rails.root, "log", "#{Rails.env}.log"))
    config.logger.formatter = Logger::Formatter.new
    config.time_zone = "Eastern Time (US & Canada)"
  end
end
