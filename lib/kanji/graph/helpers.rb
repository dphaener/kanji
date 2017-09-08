require "dry-container"
require "dry-auto_inject"
require "kanji/graph/coerce_type"
require "graphql"

module Graph
  class Helpers
    extend Dry::Container::Mixin

    Import = Dry::AutoInject(Graph::Helpers)

    register :coerce_type, -> { Graph::CoerceType.new }

    register :explain do
      ->(schema) { schema.execute GraphQL::Introspection::INTROSPECTION_QUERY }
    end

    register :generate do
      lambda do |schema, destination|
        result = JSON.pretty_generate(explain(schema))
        unless File.exist?(destination) && File.read(destination) == result
          File.write(destination, result)
        end
      end
    end
  end
end
