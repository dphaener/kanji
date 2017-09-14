require "dry/web/container"

module Kanji
  class WebContainer < Dry::Web::Container
    setting :stdout_logger

    class << self
      def configure(&block)
        super.configure_stdout_logger

        return unless self[:settings][:env] == "development"
        rack_logger = Dry::Monitor::Rack::Logger.new(self[:stdout_logger])
        rack_logger.attach(self[:rack_monitor])
      end

      def configure_stdout_logger
        config.stdout_logger = Dry::Monitor::Logger.new($stdout)
        config.stdout_logger.level = Dry::Monitor::Logger::DEBUG
        register(:stdout_logger, config.stdout_logger)
        self
      end
    end
  end
end
