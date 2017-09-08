require "spec_helper"

describe Kanji::Graph::RegisterObject do
  describe "options" do
    subject(:registrar) { Kanji::Graph::RegisterObject }

    it do
      is_expected.
        to have_option(:attributes).
        of_type(Kanji::Types::Array.member(Kanji::Type::Attribute))
    end
    it do
      is_expected.
        to have_option(:name).
        of_type(Kanji::Types::String)
    end
    it do
      is_expected.
        to have_option(:description).
        of_type(Kanji::Types::String)
    end
  end

  describe "#call" do
    subject do
      Kanji::Graph::RegisterObject.new(
        attributes: [
          Kanji::Type::Attribute.new({
            name: :email,
            type: Kanji::Types::String,
            description: "The test email",
            options: { required: true },
            resolve: nil
          }),
          Kanji::Type::Attribute.new({
            name: :posts,
            type: Kanji::Types::Array.member(Types::TestPost),
            description: "The posts for the user",
            options: {},
            resolve: nil
          })
        ],
        name: "TestUser",
        description: "The test user type"
      ).call
    end

    it { is_expected.to have_field(:email).of_type("String!") }
    it { is_expected.to have_field(:posts).of_type("[TestPostType]") }

    it "has the correct name" do
      expect(subject.name).to eql "TestUserType"
    end

    it "has the correct description" do
      expect(subject.description).to eql "The test user type"
    end
  end
end
