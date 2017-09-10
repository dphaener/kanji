require "kanji/generate"
require "kanji/generators/abstract_generator"
require "dry/core/inflector"

module Kanji
  module Generators
    class Project < AbstractGenerator
      def initialize(app_name, options = {})
        @app_name = app_name
        super(underscored_project_name)
      end

      def populate_templates
        add_bin
        add_config
        add_db
        add_log
        add_spec
        add_app
        add_lib
        add_system
        add_config_files
      end

      private
      attr_reader :app_name

      def post_process_callback
        message = <<-TEXT
\n
You're now ready to start writing your Kanji app! Congratulations!
Because this is a data driven API application, you can't do much
with it until you create some types! Get started by using a generator:
`kanji g type User email:string`

This will generate a type and some mutations for you! Then you can:
`rake db:create && rake db:migrate`

After that open up `app/query_type.rb` and add a field to your root query
type:

field :users do
  type -> { types[Types::User[:graphql_type]] }
  description "All of the users for this app"

  resolve -> (obj, args, ctx) { Types::User[:repo].all }
end

Now open up `app/schema.rb` and uncomment the lines that add the
query and mutation types.

Start your server: `kanji s` and visit `localhost:9393/graphiql` and
start exploring!
        TEXT

        generator.processor.say(message, :cyan)
      end

      def destination
        underscored_project_name
      end

      def template_scope
        {
          underscored_project_name: underscored_project_name,
          camel_cased_app_name: camel_cased_app_name
        }
      end

      def underscored_project_name
        Dry::Core::Inflector.underscore(app_name)
      end

      def camel_cased_app_name
        Dry::Core::Inflector.camelize(app_name)
      end

      def add_bin
        add_template("bin/console.tt", "bin/console")
        add_template("bin/setup", "bin/setup")
      end

      def add_config
        add_template(".env.tt", ".env")
        add_template(".env.test.tt", ".env.test")
      end

      def add_db
        add_template("db/sample_data.rb", "db/sample_data.rb")
        add_template("db/seed.rb", "db/seed.rb")
      end

      def add_app
        add_template("app/types.rb.tt", "app/types.rb")
        add_template("app/schema.rb.tt", "app/schema.rb")
        add_template("app/query_type.rb.tt", "app/query_type.rb")
        add_template("app/mutation_type.rb.tt", "app/mutation_type.rb")
        add_template("app/views/graphiql.html.erb", "app/views/graphiql.html.erb")
        add_template(".keep", "app/repositories/.keep")
        add_template(".keep", "app/types/.keep")
        add_template(".keep", "client/.keep")
      end

      def add_lib
        add_template(".keep", "lib/.keep")
      end

      def add_log
        add_template(".keep", "log/.keep")
      end

      def add_spec
        add_template(".rspec", ".rspec")

        # Base spec helpers
        add_template("spec/db_spec_helper.rb.tt", "spec/db_spec_helper.rb")
        add_template("spec/spec_helper.rb", "spec/spec_helper.rb")

        # DB support
        add_template("spec/support/db/factory.rb", "spec/support/db/factory.rb")
        add_template("spec/support/db/helpers.rb.tt", "spec/support/db/helpers.rb")
        add_template("spec/factories/example.rb", "spec/factories/example.rb")
      end

      def add_system
        add_system_lib
        add_system_boot
      end

      def add_system_lib
        add_template("system/project/container.rb.tt", "system/#{underscored_project_name}/container.rb")
        add_template("system/project/import.rb.tt", "system/#{underscored_project_name}/import.rb")
        add_template("system/project/settings.rb.tt", "system/#{underscored_project_name}/settings.rb")
        add_template("system/project/application.rb.tt", "system/#{underscored_project_name}/application.rb")
      end

      def add_system_boot
        add_template("system/boot.rb.tt", "system/boot.rb")
        add_template("system/boot/monitor.rb.tt", "system/boot/monitor.rb")
        add_template("system/boot/rom.rb.tt", "system/boot/rom.rb")
        add_template("system/boot/settings.rb.tt", "system/boot/settings.rb")
        add_template("system/boot/graph.rb.tt", "system/boot/graph.rb")
        add_template("system/boot/repos.rb.tt", "system/boot/repos.rb")
      end

      def add_config_files
        add_template(".gitignore.tt", ".gitignore")
        add_template("Gemfile", "Gemfile")
        add_template("Rakefile.tt", "Rakefile")
        add_template("config.ru.tt", "config.ru")
        add_template("README.md.tt", "README.md")
      end
    end
  end
end
