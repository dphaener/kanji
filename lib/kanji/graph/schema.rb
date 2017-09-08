require "graphql"

module Kanji
  class Graph
    class Schema
      def call(query_type, mutation_type)
        GraphQL::Schema.define do
          query -> { query_type }
          mutation -> { mutation_type }

          max_depth 10
          max_complexity 200
        end
      end
    end
  end
end
