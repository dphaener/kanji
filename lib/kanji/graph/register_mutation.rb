require "graphql"
require "dry-initializer"
require "kanji/types"
require "kanji/type/attribute"
require "kanji/graph/coerce_type"

module Kanji
  class Graph
    class RegisterMutation
      extend Dry::Initializer

      option :return_type, Kanji::Types::Class
      option :attributes, Kanji::Types::Strict::Array.member(Kanji::Type::Attribute)
      option :name, Kanji::Types::Strict::String
      option :description, Kanji::Types::Strict::String, optional: true
      option :resolve, Kanji::Types::Callable

      def call
        return_type = self.return_type
        attributes = self.attributes
        name = self.name
        description = self.description
        resolve_proc = self.resolve
        coercer = Graph::CoerceType

        GraphQL::Field.define do
          type -> { return_type }
          name name
          description description

          attributes.each do |attribute|
            argument(
              attribute.name,
              coercer.(attribute.type),
              attribute.description
            )
          end

          resolve resolve_proc
        end
      end
    end
  end
end
