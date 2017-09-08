require "thor"
require "dry/core/inflector"
require "kanji/generators/abstract_generator"

module Kanji
  module Generators
    class Type < AbstractGenerator
      def initialize(name, attributes)
        @name = name
        @attributes = attributes.map { |attr| attr.split(":") }
        super(destination)
      end

      def populate_templates
        add_type
        add_repository
        add_mutations
        add_migration
      end

      private
      attr_reader :name, :attributes

      def template_scope
        {
          type_name: type_name,
          pluralized_type_name: pluralized_type_name,
          class_name: class_name,
          pluralized_class_name: pluralized_class_name,
          attributes: attributes,
          application_class: application_class,
          lookup_type: -> (name) { lookup_type(name) },
          lookup_column_type: -> (name) { lookup_column_type(name) }
        }
      end

      def add_type
        add_template("app/types/type.rb.tt", "app/types/#{type_name}.rb")
      end

      def add_repository
        add_template("app/repositories/repo.rb.tt", "app/repositories/#{pluralized_type_name}.rb")
      end

      def destination
        "./"
      end

      def add_mutations
        fields = "\n\n      field :create#{class_name}, Types::#{class_name}[:create_mutation]\n" +
        "      field :update#{class_name}, Types::#{class_name}[:update_mutation]\n" +
        "      field :destroy#{class_name}, Types::#{class_name}[:destroy_mutation]\n"

        generator.processor.insert_into_file "./app/mutation_type.rb", fields, after: /description ".*"/
      end

      def add_migration
        add_template("migration.rb.tt", "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_create_#{pluralized_type_name}.rb")
      end

      def application_class
        @_application_class ||= Dry::Core::Inflector.camelize(File.basename(Dir.pwd))
      end

      def type_name
        @_type_name ||= Dry::Core::Inflector.underscore(name)
      end

      def pluralized_type_name
        @_pluralized_type_name ||= Dry::Core::Inflector.pluralize(type_name)
      end

      def class_name
        @_class_name ||= Dry::Core::Inflector.camelize(name)
      end

      def pluralized_class_name
        @_pluralized_class_name ||= Dry::Core::Inflector.pluralize(class_name)
      end

      def lookup_type(type_name)
        map = {
          "string" => "Kanji::Types::String",
          "integer" => "Kanji::Types::Int",
          "decimal" => "Kanji::Types::Decimal",
          "text" => "Kanji::Types::String",
          "boolean" => "Kanji::Types::Bool",
          "float" => "Kanji::Types::Float",
          "datetime" => "Kanji::Types::DateTime"
        }

        map.fetch(type_name, "Kanji::Types::Any")
      end

      def lookup_column_type(type_name)
        map = {
          "string" => "varchar(255)",
          "integer" => "integer",
          "decimal" => "numeric",
          "text" => "text",
          "boolean" => "boolean",
          "datetime" => "timestamp",
          "float" => "double precision"
        }

        map.fetch(type_name, nil)
      end
    end
  end
end
