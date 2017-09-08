require "spec_helper"

describe Kanji::Type::MutationDefiner do
  describe "extended modules" do
    subject { Kanji::Type::MutationDefiner }

    it { is_expected.to extend_module Kanji::InstanceDefine }
  end

  describe "defined instance methods" do
    subject do
      Kanji::Type::MutationDefiner.new do
        name "CreateFoo"

        argument :foo, Kanji::Types::String
        argument :bar, Kanji::Types::Bool

        return_type Kanji::Types::String

        resolve ->(foo) { foo }
      end
    end

    it { is_expected.to define_instance_method :name }
    it { is_expected.to define_instance_method :return_type }
    it { is_expected.to define_instance_method :resolve }
  end

  describe "#initialize" do
    context "when name is not given" do
      subject do
        Kanji::Type::MutationDefiner.new do
          argument :foo, Kanji::Types::String
          argument :bar, Kanji::Types::Bool

          return_type Kanji::Types::String

          resolve ->(foo) { foo }
        end
      end

      it "raises an exception" do
        expect { subject }.
          to raise_exception(Kanji::AttributeError)
      end
    end

    context "when at least one argument is not given" do
      subject do
        Kanji::Type::MutationDefiner.new do
          name "CreateFoo"

          return_type Kanji::Types::String

          resolve ->(foo) { foo }
        end
      end

      it "raises an exception" do
        expect { subject }.
          to raise_exception(Kanji::AttributeError)
      end
    end

    context "when return_type is not given" do
      subject do
        Kanji::Type::MutationDefiner.new do
          name "CreateFoo"

          argument :foo, Kanji::Types::String
          argument :bar, Kanji::Types::Bool

          resolve ->(foo) { foo }
        end
      end

      it "raises an exception" do
        expect { subject }.
          to raise_exception(Kanji::AttributeError)
      end
    end

    context "when resolve is not given" do
      subject do
        Kanji::Type::MutationDefiner.new do
          name "CreateFoo"

          argument :foo, Kanji::Types::String
          argument :bar, Kanji::Types::Bool

          return_type Kanji::Types::String
        end
      end

      it "raises an exception" do
        expect { subject }.
          to raise_exception(Kanji::AttributeError)
      end
    end
  end

  describe "#argument" do
    context "when the given argument exists" do
      subject do
        Kanji::Type::MutationDefiner.new do
          name "CreateFoo"

          argument :foo, Kanji::Types::String
          argument :foo, Kanji::Types::Bool

          return_type Kanji::Types::String

          resolve ->(foo) { foo }
        end
      end

      it "raises an exception" do
        expect { subject }.
          to raise_exception(Kanji::ArgumentError)
      end
    end

    context "when the given argument is new" do
      subject do
        Kanji::Type::MutationDefiner.new do
          name "CreateFoo"

          argument :foo, Kanji::Types::String
          argument :bar, Kanji::Types::Bool

          return_type Kanji::Types::String

          resolve ->(foo) { foo }
        end
      end

      it "adds the argument" do
        arguments = subject.instance_variable_get(:@_arguments).map(&:name)
        expect(arguments).to match_array ["foo", "bar"]
      end
    end
  end

  describe "#call" do
    subject do
      Kanji::Type::MutationDefiner.new do
        name "CreateFoo"

        argument :foo, Kanji::Types::String
        argument :bar, Kanji::Types::Bool

        return_type Kanji::Types::String

        resolve "Foo"
      end
    end

    it "creates a mutation" do
      expected = Kanji::Type::Mutation.new({
        name: "CreateFoo",
        return_type: Kanji::Types::String,
        arguments: [
          Kanji::Type::Argument.new({
            name: "foo",
            type: Kanji::Types::String,
            options: {}
          }),
          Kanji::Type::Argument.new({
            name: "bar",
            type: Kanji::Types::Bool,
            options: {}
          })
        ],
        resolve: "Foo"
      })

      expect(subject.call).to eql expected
    end
  end
end
