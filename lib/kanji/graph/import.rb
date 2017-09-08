require "dry-auto_inject"
require "kanji/graph/container"

module Kanji
  class Graph
    Import = Dry::AutoInject(Graph::Container)
  end
end
