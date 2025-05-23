require_relative "boot"

ENV['RANSACK_FORM_BUILDER'] = '::SimpleForm::FormBuilder'

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CloseTasksApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.active_storage.replace_on_assign_to_many = false

    # config.active_job.queue_adapter = :sidekiq

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    I18n.available_locales = [:en, :ru]

    I18n.default_locale = :ru

    config.time_zone = 'Moscow'

    config.active_job.queue_adapter = :sidekiq
  end
end
