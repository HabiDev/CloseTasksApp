require 'sidekiq-scheduler'

Sidekiq.configure_server do |config|
  config.on(:startup) do
    schedule_file = Rails.root.join('config', 'sidekiq.yml')
    if File.exist?(schedule_file)
      config_data = YAML.load_file(schedule_file).deep_symbolize_keys
      schedule = config_data.dig(:scheduler, :schedule)
      if schedule
        Sidekiq.schedule = schedule
        Sidekiq::Scheduler.reload_schedule!
        Rails.logger.info "[SidekiqScheduler] Schedule loaded"
      else
        Rails.logger.warn "[SidekiqScheduler] Schedule not found in YAML"
      end
    else
      Rails.logger.warn "[SidekiqScheduler] YAML file not found"
    end
  end
end