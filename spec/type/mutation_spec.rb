require "spec_helper"

describe Kanji::Type::Mutation do
  it "is a value object" do
    expect(Kanji::Type::Mutation.superclass).to eq Dry::Struct::Value
  end

  context "attributes" do
    subject { Kanji::Type::Mutation }

    it { is_expected.to have_attribute(:name).of_type(Kanji::Types::String) }
    it do
      is_expected.
        to have_attribute(:return_type).
        of_type(Kanji::Types::Class)
    end
    it do
      is_expected.
        to have_attribute(:arguments).
        of_type(Kanji::Types::Strict::Array.member(Kanji::Type::Argument))
    end
    it { is_expected.to have_attribute(:resolve).of_type(Kanji::Types::Class) }
    it { is_expected.to have_attribute(:name).of_type(Kanji::Types::String) }
  end
end
