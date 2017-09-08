require "kanji/application"
require "schema"
require_relative "container"

module TestApp
  class Application < Kanji::Application
    configure do |config|
      config.container = Container
    end

    route do |r|
      r.is "graphiql" do
        render "graphiql.html"
      end

      r.post "api" do
        r.resolve "graph.query" do |query|
          payload = JSON.parse(request.body.read)
          result = query.call(
            schema: TestApp::Schema,
            query: payload["query"],
            variables: payload["variables"],
            context: {}
          )
          result.to_json
        end
      end
    end

    error do |e|
      self.class[:rack_monitor].instrument(:error, exception: e)
      raise e
    end
  end
end
