require "kanji/graph/container"

TestApp::Container.namespace :graph do |container|
  container.finalize :graph do
    start do
      container.register :query, Kanji::Graph::Container[:query]
    end
  end
end
