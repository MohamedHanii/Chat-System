require 'sidekiq'
require 'sidekiq-cron'

sidekiq_config = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}/1" }
schedule_file = 'config/schedule.yml'

Sidekiq.configure_server do |config|
    config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
    config.redis = sidekiq_config
end

if File.exists?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

