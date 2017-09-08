require "graphql"

module Kanji
  class Graph
    class CoerceType
      def self.call(type)
        if array_type?(type)
          member_type = get_member_type(type)
          graphql_type = get_graphql_type(member_type)
          graphql_type.to_list_type
        else
          get_graphql_type(type)
        end
      end

      private

      TYPE_MAP = {
        "String" => "String",
        "Integer" => "Int",
        "Float" => "Float",
        "FalseClass" => "Boolean",
        "TrueClass | FalseClass" => "Boolean",
        "FalseClass | TrueClass" => "Boolean"
      }

      def self.get_graphql_type(type)
        return type if type.is_a?(GraphQL::ObjectType)

        type_string = TYPE_MAP[get_primitive_type(type)]

        if type.optional?
          GraphQL::Define::TypeDefiner.instance.send(type_string)
        else
          !GraphQL::Define::TypeDefiner.instance.send(type_string)
        end
      end

      def self.get_primitive_type(type)
        type.optional? ?
          type.right.primitive.to_s :
          type.primitive.to_s
      end

      def self.get_member_type(type)
        member_type = type.options[:member] || type.type.options[:member]

        if has_ancestor?(member_type, Kanji::Type)
          member_type[:graphql_type]
        else
          member_type
        end
      end

      def self.array_type?(type)
        return type.primitive == Array if defined?(type.primitive)
        defined?(type.type) && type.type.primitive == Array
      end

      def self.has_ancestor?(type, ancestor)
        return false unless type.respond_to?(:ancestors)
        type.ancestors.include?(ancestor)
      end
    end
  end
end
