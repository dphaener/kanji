module Types
  class TestPost < Kanji::Type
    name "TestPost"
    description "A test post"

    attribute :title, Kanji::Types::String, "A test title", required: true
    attribute :body, Kanji::Types::String, "A test body", required: true
  end
end
