require "thor"

module Kanji
  class CLI < Thor
    class Generate < Thor
      desc "type NAME ATTRIBUTES", "Generate a new type and all of it's dependencies"
      def type(name, *attributes)
        require "kanji/generators/type"
        Generators::Type.new(name, attributes).call
      end
    end
  end
end
