require "spec_helper"

describe Kanji::Types::Callable do
  subject { Kanji::Types::Callable }

  describe "modules" do
    it { is_expected.to extend_module Kanji::Types::TypeInterface }
  end

  describe ".call" do
    context "when the object is valid" do
      it "returns the object" do
        allow(subject).to receive(:valid?) { true }
        obj = proc { "Foo" }
        result = subject.call(obj)
        expect(result).to eq obj
      end
    end

    context "when the object is not valid" do
      it "raises a ConstraintError" do
        allow(subject).to receive(:valid?) { false }
        obj = "foo"
        expect {
          subject.call(obj)
        }.to raise_exception(Dry::Types::ConstraintError)
      end
    end
  end

  describe ".valid?" do
    context "when the object responds to call" do
      it "returns true" do
        expect(subject.valid?(proc { "Foo" })).to be true
      end
    end

    context "when the object does not respond to call" do
      it "returns false" do
        expect(subject.valid?("Foo")).to be false
      end
    end
  end
end
