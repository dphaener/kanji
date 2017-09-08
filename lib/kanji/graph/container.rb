require "dry-container"
require "kanji/graph/register_object"
require "kanji/graph/register_mutation"
require "kanji/graph/query"
require "kanji/graph/schema"

module Kanji
  class Graph
    class Container
      extend Dry::Container::Mixin

      register :register_object, -> (params) { RegisterObject.new(params) }
      register :register_mutation, -> (params) { RegisterMutation.new(params) }
      register :query, Kanji::Graph::Query
      register :schema, Kanji::Graph::Schema
    end
  end
end
