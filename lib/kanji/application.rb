require "roda"
require "roda/plugins/flow"
require "dry-configurable"
require "dry-monitor"

module Kanji
  class Application < ::Roda
    extend Dry::Configurable

    setting :container, reader: true

    plugin :render, views: "app/views"
    plugin :error_handler
    plugin :flow

    def self.configure(&block)
      super.tap do
        use(container[:rack_monitor]) if container.config.listeners
      end
    end

    def self.resolve(name)
      container[name]
    end

    def self.[](name)
      container[name]
    end

    def self.root
      container.config.root
    end

    def notifications
      self.class[:notifications]
    end
  end
end
