require "sequel"
require "rom"
require "rom/sql"

TestApp::Container.namespace :persistence do |container|
  container.finalize :rom do
    init do
      use :settings
      use :monitor

      ROM::SQL.load_extensions :postgres

      Sequel.database_timezone = :utc
      Sequel.application_timezone = :local

      rom_config = ROM::Configuration.new(
        :sql,
        container["settings"].database_url,
        extensions: %i[error_sql pg_array pg_json],
      )

      rom_config.plugin :sql, relations: :instrumentation do |plugin_config|
        plugin_config.notifications = notifications
      end

      rom_config.plugin :sql, relations: :auto_restrictions

      container.register "config", rom_config
      container.register "db", rom_config.gateways[:default].connection
    end

    start do
      config = container["persistence.config"]
      container.register "rom", ROM.container(config)
    end
  end
end
