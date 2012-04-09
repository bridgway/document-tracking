require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  Bundler.require(*Rails.groups(:assets => %w(development test)))
end

module Documents
  class Application < Rails::Application
    config.active_record.observers = :document_observer
    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_record.timestamped_migrations = false
    config.assets.enabled = true
    config.assets.version = '1.0'
  end
end
