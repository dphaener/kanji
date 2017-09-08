require "spec_helper"

describe Kanji::Graph::RegisterMutation do
  describe "options" do
    subject(:registrar) { Kanji::Graph::RegisterMutation }

    it do
      is_expected.
        to have_option(:return_type).
        of_type(Kanji::Types::Class)
    end
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
    it do
      is_expected.
        to have_option(:resolve).
        of_type(Kanji::Types::Callable)
    end
  end

  describe "#call" do
    subject do
      Kanji::Graph::RegisterMutation.new(
        attributes: [
          Kanji::Type::Attribute.new({
            name: :email,
            type: Kanji::Types::String,
            description: "The test email",
            options: { required: true },
            resolve: nil
          })
        ],
        name: "CreateUserMutation",
        description: "Create a new user",
        return_type: Types::TestUser,
        resolve: -> (obj, args, context) { puts obj }
      ).call
    end

    it { is_expected.to be_of_type(Types::TestUser) }
    it { is_expected.to have_argument(:email).of_type("String!") }

    it "has the correct name" do
      expect(subject.name).to eql "CreateUserMutation"
    end

    it "has the correct description" do
      expect(subject.description).to eql "Create a new user"
    end
  end
end
