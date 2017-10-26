require "spec_helper"

describe Kanji::Graph::CoerceType do
  describe ".call" do
    context "with a string type" do
      context "and it is required" do
        it "properly finds the type string" do
          result = Kanji::Graph::CoerceType.call(Kanji::Types::String)
          expect(result.to_s).to eq "String!"
        end
      end

      context "and it is not required" do
        it "properly finds the type string" do
          result = Kanji::Graph::CoerceType.call(Kanji::Types::String.optional)
          expect(result.to_s).to eq "String"
        end
      end
    end

    context "with an integer type" do
      context "and it is required" do
        it "properly finds the type string" do
          result = Kanji::Graph::CoerceType.call(Kanji::Types::Int)
          expect(result.to_s).to eq "Int!"
        end
      end

      context "and it is not required" do
        it "properly finds the type string" do
          result = Kanji::Graph::CoerceType.call(Kanji::Types::Int.optional)
          expect(result.to_s).to eq "Int"
        end
      end
    end

    context "with a float type" do
      context "and it is required" do
        it "properly finds the type string" do
          result = Kanji::Graph::CoerceType.call(Kanji::Types::Float)
          expect(result.to_s).to eq "Float!"
        end
      end

      context "and it is not required" do
        it "properly finds the type string" do
          result = Kanji::Graph::CoerceType.call(Kanji::Types::Float.optional)
          expect(result.to_s).to eq "Float"
        end
      end
    end

    context "with a boolean type" do
      context "and it is required" do
        it "creates the proper type" do
          type = Kanji::Types::Bool
          result = Kanji::Graph::CoerceType.call(type)
          expect(result.to_s).to eq "Boolean!"
        end
      end

      context "and it is not required" do
        it "creates the proper type" do
          type = Kanji::Types::Bool.optional
          result = Kanji::Graph::CoerceType.call(type)
          expect(result.to_s).to eq "Boolean"
        end
      end
    end

    context "with an array of types" do
      context "and the member type is a Kanji::Type" do
        it "creates the proper type" do
          type = Kanji::Types::Array.of(Types::TestPost).default([])
          result = Kanji::Graph::CoerceType.call(type)
          expect(result.to_s).to eq "[TestPostType]"
        end
      end

      context "and the member type is a primitive type" do
        it "creates the proper type" do
          type = Kanji::Types::Array.of(String).default([])
          result = Kanji::Graph::CoerceType.call(type)
          expect(result.to_s).to eq "[String!]"
        end
      end
    end
  end
end
