require "rerun"
require "pathname"
require "dry/core/inflector"

module Kanji
  class CLI < Thor
    class Server
      def self.start(options = {})
        Rerun::Runner.keep_running(
          "thin -R config.ru -a 127.0.0.1 -p #{options["port"]} -D start",
          default_options
        )
      end

      def self.default_options
        {
          pattern: "**/*.rb",
          signal: "TERM",
          notify: false,
          name: app_name,
          ignore: [],
          dir: ["app", "system"],
          cmd: "rackup config.ru"
        }
      end

      def self.app_name
        Dry::Core::Inflector.camelize(Pathname.getwd.basename.to_s)
      end
    end
  end
end
