require "dry-validation"
require "graphql"
require "dry/core/class_builder"
require "dry/core/constants"
require "dry/core/inflector"
require "kanji/type/attribute"
require "kanji/graph/register_object"
require "kanji/graph/register_mutation"
require "kanji/type/attribute_definer"

module Kanji
  class Type
    module ClassInterface
      include Dry::Core::Constants

      attr_reader :_attributes, :_name, :_description, :_repo_name,
        :_associations

      def graphql_type(klass)
        Kanji::Graph::RegisterObject.new(
          attributes: klass._attributes + klass._associations,
          name: klass._name,
          description: klass._description
        ).call
      end

      def inherited(klass)
        super

        klass.instance_variable_set(:@_attributes, [])
        klass.instance_variable_set(:@_values, {})
        klass.instance_variable_set(:@_associations, [])

        klass.attribute(:id, Kanji::Types::Int, "The primary key")

        TracePoint.trace(:end) do |t|
          if klass == t.self
            self.finalize(klass)
            t.disable
          end
        end
      end

      def finalize(klass)
        klass.register :graphql_type, graphql_type(klass)
        klass.register :schema, -> { klass.register_schema }
        klass.register :value_object, -> { klass.create_value_object }
        klass.instance_variable_set(:@_repo_name, get_repo_name(klass))
      end

      def get_repo_name(klass)
        name = Dry::Core::Inflector.underscore(klass._name)
        Dry::Core::Inflector.pluralize(name).to_sym
      end

      def name(name)
        @_name = name
      end

      def description(description)
        @_description = description
      end

      def attribute(name, type = nil, description = nil, **kwargs, &block)
        if @_attributes.map(&:name).include?(name)
          fail AttributeError, "Attribute #{name} is already defined"
        else
          @_attributes <<
            AttributeDefiner.new(name, type, description, kwargs, &block).call
        end
      end

      def assoc(name, type = nil, description = nil, **kwargs, &block)
        if @_associations.map(&:name).include?(name)
          fail AttributeError, "Association #{name} is already defined"
        else
          @_associations <<
          AttributeDefiner.new(name, type, description, kwargs, &block).call
        end
      end

      def demodulized_type_name
        @_demodulized_type_name ||= Dry::Core::Inflector.demodulize(self.to_s)
      end

      def create(&block)
        register :create_mutation do
          Kanji::Graph::RegisterMutation.new(
            return_type: resolve(:graphql_type),
            attributes: @_attributes.reject { |attr| attr.name == :id },
            name: "Create#{demodulized_type_name}Mutation",
            description: "Create a new #{demodulized_type_name}.",
            resolve: block
          ).call
        end
      end

      def update(&block)
        register :update_mutation do
          Kanji::Graph::RegisterMutation.new(
            return_type: resolve(:graphql_type),
            attributes: @_attributes,
            name: "Update#{demodulized_type_name}Mutation",
            description: "Update an instance of #{demodulized_type_name}.",
            resolve: block
          ).call
        end
      end

      def destroy(&block)
        register :destroy_mutation do
          Kanji::Graph::RegisterMutation.new(
            return_type: resolve(:graphql_type),
            attributes: [@_attributes.find { |attr| attr.name == :id }],
            name: "Destroy#{demodulized_type_name}Mutation",
            description: "Destroy a #{demodulized_type_name}.",
            resolve: block
          ).call
        end
      end

      def register_schema
        attributes = _attributes

        Dry::Validation.JSON do
          configure { config.type_specs = true }

          attributes.each do |attribute|
            if attribute.options[:required]
              required(attribute.name, attribute.type).filled
            else
              optional(attribute.name, attribute.type).maybe
            end
          end
        end
      end

      def create_value_object
        builder = Dry::Core::ClassBuilder.new(
          name: "#{instance_variable_get(:@_name)}Value",
          parent: Dry::Struct::Value
        )
        klass = builder.call

        klass.constructor_type(:schema)

        instance_variable_get(:@_attributes).each do |attribute|
          klass.attribute(attribute.name, attribute.type)
        end

        klass
      end
    end
  end
end

