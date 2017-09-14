require "kanji/web_container"

module TestApp
  class Container < Kanji::WebContainer
    configure do
      config.name = :test_app
      config.listeners = true
      config.auto_register = %w[app]
    end

    load_paths! "app"
  end
end
