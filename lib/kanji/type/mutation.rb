require "dry-struct"
require "kanji/types"

module Kanji
  class Type
    class Mutation < Dry::Struct::Value
      attribute :name, Kanji::Types::String
      attribute :return_type, Kanji::Types::Class
      attribute :arguments, Kanji::Types::Strict::Array.member(Kanji::Type::Argument)
      attribute :resolve, Kanji::Types::Class
    end
  end
end
