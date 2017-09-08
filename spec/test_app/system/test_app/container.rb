require "dry/web/container"

module TestApp
  class Container < Dry::Web::Container
    configure do
      config.name = :test_app
      config.listeners = true
      config.auto_register = %w[app]
    end

    load_paths! "app"
  end
end
