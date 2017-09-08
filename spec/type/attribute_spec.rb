require "spec_helper"

describe Kanji::Type::Attribute do
  context "attributes" do
    subject { Kanji::Type::Attribute }

    it { is_expected.to have_attribute(:name).of_type(Kanji::Types::String) }
    it { is_expected.to have_attribute(:type).of_type(Kanji::Types::Class) }
    it { is_expected.to have_attribute(:description).of_type(Kanji::Types::String) }
    it { is_expected.to have_attribute(:options).of_type(Kanji::Types::Hash) }
    it { is_expected.to have_attribute(:resolve).of_type(Kanji::Types::Callable.optional) }
  end
end
