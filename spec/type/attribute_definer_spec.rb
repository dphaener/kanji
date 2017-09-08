require "spec_helper"

describe Kanji::Type::AttributeDefiner do
  describe "extended modules" do
    subject { Kanji::Type::AttributeDefiner }

    it { is_expected.to extend_module Kanji::InstanceDefine }
  end

  describe "defined instance methods" do
    subject { Kanji::Type::AttributeDefiner.new(:foo, Kanji::Types::String) }

    it { is_expected.to define_instance_method :type }
    it { is_expected.to define_instance_method :description }
    it { is_expected.to define_instance_method :options }
    it { is_expected.to define_instance_method :resolve }
  end

  describe "#initialize" do
    context "when type is given" do
      context "and block with type definition is given" do
        subject do
          Kanji::Type::AttributeDefiner.new(:foo, Kanji::Types::String) do
            type Kanji::Types::Bool
          end.call
        end

        it "overwrites the given type" do
          expect(subject.type).to eql Kanji::Types::Bool
        end
      end

      context "and block with no type definition is given" do
        subject do
          Kanji::Type::AttributeDefiner.new(:foo, Kanji::Types::String) do
            description "Bar"
          end.call
        end

        it "does not overwrite the given type" do
          expect(subject.type).to eql Kanji::Types::String
        end
      end

      context "and no block is given" do
        subject do
          Kanji::Type::AttributeDefiner.new(:foo, Kanji::Types::String).call
        end

        it "sets the type" do
          expect(subject.type).to eql Kanji::Types::String
        end
      end
    end

    context "when type is not given" do
      context "and block with type definition is given" do
        subject do
          Kanji::Type::AttributeDefiner.new(:foo) do
            type Kanji::Types::String
          end.call
        end

        it "sets the type from the block" do
          expect(subject.type).to eql Kanji::Types::String
        end
      end

      context "and block with no type definition is given" do
        subject do
          Kanji::Type::AttributeDefiner.new(:foo) do
            description "Foo bar"
          end
        end

        it "raises an exception" do
          expect { subject.call }.
            to raise_exception(Kanji::AttributeError)
        end
      end

      context "and no block is given" do
        subject { Kanji::Type::AttributeDefiner.new(:foo) }

        it "raises an exception" do
          expect { subject.call }.
            to raise_exception(Kanji::AttributeError)
        end
      end
    end

    context "when description is given" do
      context "and block with description is given" do
        subject do
          Kanji::Type::AttributeDefiner.new(:foo, Kanji::Types::String, "Foo") do
            description "Bar"
          end.call
        end

        it "overwrites the given description" do
          expect(subject.description).to eql "Bar"
        end
      end

      context "and block with no description is given" do
        subject do
          Kanji::Type::AttributeDefiner.new(:foo, Kanji::Types::String, "Foo") do
          end.call
        end

        it "does not overwrite the given description" do
          expect(subject.description).to eql "Foo"
        end
      end

      context "and no block is given" do
        subject do
          Kanji::Type::AttributeDefiner.new(
            :foo,
            Kanji::Types::String,
            "Foo"
          ).call
        end

        it "does not overwrite the given description" do
          expect(subject.description).to eql "Foo"
        end
      end
    end

    context "when description is not given" do
      context "and block with description is given" do
        subject do
          Kanji::Type::AttributeDefiner.new(:foo, Kanji::Types::String) do
            description "Bar"
          end.call
        end

        it "sets the description" do
          expect(subject.description).to eql "Bar"
        end
      end

      context "and block with no description is given" do
        subject do
          Kanji::Type::AttributeDefiner.new(:foo) do
            type Kanji::Types::String
          end.call
        end

        it "does not set the description" do
          expect(subject.description).to be nil
        end
      end

      context "and no block is given" do
        subject do
          Kanji::Type::AttributeDefiner.new(:foo, Kanji::Types::String).call
        end

        it "does not set the description" do
          expect(subject.description).to be nil
        end
      end
    end

    context "when keyword arguments are present" do
      subject do
        Kanji::Type::AttributeDefiner.new(:foo, bar: :baz) do
          type Kanji::Types::String
        end.call
      end

      it "sets the options" do
        expect(subject.options).to eql({ bar: :baz })
      end
    end

    context "when keyword arguments are not present" do
      subject do
        Kanji::Type::AttributeDefiner.new(:foo) do
          type Kanji::Types::String
        end.call
      end

      it "does not set the options" do
        expect(subject.options).to eql({})
      end
    end
  end

  describe "#call" do
    resolve_proc = -> () { "Bar" }

    subject do
      Kanji::Type::AttributeDefiner.new(:foo, bar: :baz) do
        type Kanji::Types::String
        description "Foo"
        resolve resolve_proc
      end
    end

    it "creates a new attribute" do
      expected = Kanji::Type::Attribute.new({
        name: :foo,
        type: Kanji::Types::String,
        description: "Foo",
        options: { bar: :baz },
        resolve: resolve_proc
      })

      expect(subject.call).to eql expected
    end
  end
end
