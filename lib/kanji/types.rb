require "dry-types"
require_relative "./types/callable"

module Kanji
  module Types
    include Dry::Types.module

    ID = String | Integer
    Email = String.constrained(format: /.+\@.+\..+/)
  end
end
