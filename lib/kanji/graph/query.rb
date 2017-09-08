require "graphql"

module Kanji
  class Graph
    class Query
      def self.call(schema:, query:, variables: {}, context: {})
        GraphQL::Query.new(
          schema.call,
          query,
          variables: variables,
          context: context
        ).result
      end
    end
  end
end
