require "thor"

module Kanji
  class CLI < Thor
    desc "new APP", "Generate a new Kanji project"
    def new(app_name)
      require "kanji/generators/project"
      Generators::Project.new(app_name).call
    end

    map "n" => "new"

    desc "generate GENERATOR", "Generate a new item for this project"
    require "kanji/cli/generate"
    subcommand "generate", CLI::Generate

    map "g" => "generate"

    desc "server", "Start the application server"
    method_option :port, default: 3300, aliases: "p"
    def server
      require "kanji/cli/server"
      require_relative "#{Dir.pwd}/system/boot"
      CLI::Server.start(options)
    end

    map "s" => "server"

    desc "console", "Open up the application console"
    def console
      require "bundler/setup"
      require "dry/web/console"
      require_relative "#{Dir.pwd}/system/boot"
      Dry::Web::Console.start
    end

    map "c" => "console"
  end
end
