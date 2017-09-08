require "dry/system/container"
require "kanji/graph/container"

module Kanji
  class Container < Dry::System::Container
    configure do |config|
      config.root = Pathname.new("./")
    end

    load_paths!("lib/kanji/type", "lib/kanji/graph")
  end
end
