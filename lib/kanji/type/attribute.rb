require "dry-struct"
require "kanji/types"

module Kanji
  class Type
    class Attribute < Dry::Struct
      attribute :name, Kanji::Types::String
      attribute :type, Kanji::Types::Class
      attribute :description, Kanji::Types::String
      attribute :options, Kanji::Types::Hash
      attribute :resolve, Kanji::Types::Callable.optional
    end
  end
end
