require "spec_helper"

describe Kanji::Types::TypeInterface do
  subject do
    double(
      Class,
      valid?: valid,
      constraint_error: "Foo"
    ).extend(Kanji::Types::TypeInterface)
  end

  let(:valid) { true }

  describe "#try" do
    context "with a block" do
      context "when the object is valid" do
        it "returns a success object" do
          obj = { a: 1 }
          result = subject.try(obj) { "foo" }
          expect(result.class).to eq Dry::Types::Result::Success
          expect(result.success?).to be true
          expect(result.input).to eq obj
        end
      end

      context "when the object is not valid" do
        let(:valid) { false }

        it "yields the result to the block" do
          obj = "Foo"
          subject.try(obj) do |result|
            expect(result.class).to eq Dry::Types::Result::Failure
            expect(result.success?).to be false
            expect(result.input).to eq obj
          end
        end
      end
    end

    context "without a block" do
      context "when the object is valid" do
        it "returns a success object" do
          obj = { a: 1 }
          result = subject.try(obj) { "foo" }
          expect(result.class).to eq Dry::Types::Result::Success
          expect(result.success?).to be true
          expect(result.input).to eq obj
        end
      end

      context "when the object is not valid" do
        let(:valid) { false }

        it "returns a failiure object" do
          obj = "Foo"
          result = subject.try(obj)
          expect(result.class).to eq Dry::Types::Result::Failure
          expect(result.success?).to be false
          expect(result.input).to eq obj
        end
      end
    end
  end

  describe "#constrained?" do
    it "returns true" do
      expect(subject.constrained?).to be true
    end
  end

  describe "#success" do
    it "returns a dry types success object" do
      success = subject.success("Foo")
      expect(success).to be_an_instance_of(Dry::Types::Result::Success)
      expect(success.input).to eq "Foo"
    end
  end

  describe "#failure" do
    it "returns a dry types failure object" do
      error = Dry::Types::ConstraintError.new("Foo", "This is an error")
      failure = subject.failure("Foo", error)
      expect(failure).to be_an_instance_of(Dry::Types::Result::Failure)
      expect(failure.input).to eq "Foo"
      expect(failure.error).to eq error
    end
  end

  describe "#|" do
    it "returns a constrained sum object" do
      result = subject | Kanji::Types::String
      expect(result.class).to eq Dry::Types::Sum::Constrained
      expect(result.left).to eq subject
      expect(result.right).to eq Kanji::Types::String
    end
  end

  describe "#optional" do
    it "returns a sum object" do
      result = subject.optional
      expect(result.class).to eq Dry::Types::Sum
      expect(result.left).to eq Kanji::Types::Nil
      expect(result.right).to eq subject
    end
  end
end
