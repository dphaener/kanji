require "dry-struct"
require "kanji/types"

module Kanji
  class Type
    class Argument < Dry::Struct
      attribute :name, Kanji::Types::String
      attribute :type, Kanji::Types::Class
      attribute :options, Kanji::Types::Hash
    end
  end
end
