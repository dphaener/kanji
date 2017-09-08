require "spec_helper"

describe Kanji::Graph::CoerceType do
  describe ".call" do
    context "when the type is required" do
      it "properly finds the type string" do
        result = Kanji::Graph::CoerceType.call(Kanji::Types::String)
        expect(result.to_s).to eq "String!"
      end
    end

    context "when the type is not required" do
      it "properly finds the type string" do
        result = Kanji::Graph::CoerceType.call(Kanji::Types::String.optional)
        expect(result.to_s).to eq "String"
      end
    end

    context "when the type is an array" do
      context "and the member type is a Kanji::Type" do
        it "creates the proper type" do
          type = Kanji::Types::Array.member(Types::TestPost).default([])
          result = Kanji::Graph::CoerceType.call(type)
          expect(result.to_s).to eq "[TestPostType]"
        end
      end

      context "and the member type is a primitive type" do
        it "creates the proper type" do
          type = Kanji::Types::Array.member(String).default([])
          result = Kanji::Graph::CoerceType.call(type)
          expect(result.to_s).to eq "[String!]"
        end
      end
    end
  end
end
