require "graphql"
require "dry-initializer"
require "kanji/types"
require "kanji/type/attribute"
require "kanji/graph/coerce_type"

module Kanji
  class Graph
    class RegisterObject
      extend Dry::Initializer

      option :attributes, Types::Strict::Array.member(Type::Attribute)
      option :name, Types::Strict::String
      option :description, Types::Strict::String, optional: true

      def call
        name = "#{self.name}Type"
        attributes = self.attributes
        description = self.description
        coercer = Graph::CoerceType

        GraphQL::ObjectType.define do
          name name
          description description

          attributes.each do |attribute|
            field attribute.name do
              type -> { coercer.(attribute.type) }
              description attribute.description

              if attribute.resolve
                resolve attribute.resolve
              end
            end
          end
        end
      end
    end
  end
end