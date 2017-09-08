TestApp::Container.namespace :graph do |container|
  container.finalize :graph do
    init do
      require "kanji/graph/container"
    end

    start do
      container.register :query, Kanji::Graph::Container[:query]
    end
  end
end
