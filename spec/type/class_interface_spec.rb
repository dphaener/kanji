require "spec_helper"

describe Kanji::Type::ClassInterface do
  describe "attributes" do
    context "TestUser" do
      it "sets the name attribute" do
        expect(Types::TestUser._name).to eql "TestUser"
      end

      it "sets the description attribute" do
        expect(Types::TestUser._description).to eql "A test user"
      end
    end

    context "TestPost" do
      it "sets the name attribute" do
        expect(Types::TestPost._name).to eql "TestPost"
      end

      it "sets the description attribute" do
        expect(Types::TestPost._description).to eql "A test post"
      end
    end
  end

  describe "class macros" do
    describe ".attribute" do
      context "TestUser" do
        it "pushes the attribute into an array" do
          expected = [
            Kanji::Type::Attribute.new({
              name: :id,
              type: Kanji::Types::Int,
              description: "The primary key",
              options: {},
              resolve: nil
            }),
            Kanji::Type::Attribute.new({
              name: :email,
              type: Kanji::Types::String,
              description: "The test email",
              options: { required: true },
              resolve: nil
            }),
            Kanji::Type::Attribute.new({
              name: :name,
              type: Kanji::Types::String.optional,
              description: "The test name",
              options: {},
              resolve: nil
            })
          ]

          expect(Types::TestUser._attributes).to eql expected
        end
      end

      context "TestPost" do
        it "pushes the attribute into an array" do
          expected = [
            Kanji::Type::Attribute.new({
              name: :id,
              type: Kanji::Types::Int,
              description: "The primary key",
              options: {},
              resolve: nil
            }),
            Kanji::Type::Attribute.new({
              name: :title,
              type: Kanji::Types::String,
              description: "A test title",
              options: { required: true },
              resolve: nil
            }),
            Kanji::Type::Attribute.new({
              name: :body,
              type: Kanji::Types::String,
              description: "A test body",
              options: { required: true },
              resolve: nil
            })
          ]

          expect(Types::TestPost._attributes).to eql expected
        end
      end

      it "doesn't allow duplicate attribute names" do
        expect do
          Types::TestUser.attribute(:email, Kanji::Types::String, "Test")
        end.to raise_exception(
          Kanji::AttributeError,
          "Attribute email is already defined"
        )
      end
    end

    describe ".assoc" do
      it "adds the associations to the array" do
        expected = [
          Kanji::Type::Attribute.new({
            name: :posts,
            type: Kanji::Types::Array.member(Types::TestPost).default([]),
            description: "All of the posts for the user",
            options: {},
            resolve: nil
          })
        ]

        expect(Types::TestUser._associations).to eql expected
      end
    end

    describe ".create" do
      subject { Types::TestUser[:create_mutation] }

      it { is_expected.to have_argument(:email).of_type("String!") }
      it { is_expected.to have_argument(:name).of_type("String") }

      it "registers the create mutation" do
        expect(subject.class.name).to eql "GraphQL::Field"
        expect(subject.name).to eql "CreateTestUserMutation"
        expect(subject.description).to eql "Create a new TestUser."
      end
    end

    describe ".update" do
      subject { Types::TestUser[:update_mutation] }

      it { is_expected.to have_argument(:id).of_type("Int!") }
      it { is_expected.to have_argument(:email).of_type("String!") }
      it { is_expected.to have_argument(:name).of_type("String") }

      it "registers the create mutation" do
        expect(subject.class.name).to eql "GraphQL::Field"
        expect(subject.name).to eql "UpdateTestUserMutation"
        expect(subject.description).to eql "Update an instance of TestUser."
      end
    end

    describe ".destroy" do
      subject { Types::TestUser[:destroy_mutation] }

      it { is_expected.to have_argument(:id).of_type("Int!") }

      it "registers the create mutation" do
        expect(subject.class.name).to eql "GraphQL::Field"
        expect(subject.name).to eql "DestroyTestUserMutation"
        expect(subject.description).to eql "Destroy a TestUser."
      end
    end
  end

  describe "container registry" do
    describe "schema" do
      subject { Types::TestUser[:schema] }

      it "registers the schema" do
        expect(subject.type_map.keys).to match_array [:id, :name, :email]
      end

      it "registers optional attributes as optional" do
        expect(subject.type_map[:name].optional?).to be true
      end

      it "registers the other schema" do
        expect(Types::TestPost[:schema].type_map.keys).to eq [:id, :title, :body]
      end
    end

    describe "graphql_type" do
      context "TestUser" do
        subject { Types::TestUser[:graphql_type] }

        it { is_expected.to have_field(:email).of_type("String!") }
        it { is_expected.to have_field(:name).of_type("String") }
      end

      context "TestPost" do
        subject { Types::TestPost[:graphql_type] }

        it { is_expected.to have_field(:title).of_type("String!") }
        it { is_expected.to have_field(:body).of_type("String!") }
      end
    end

    describe "value_object" do
      context "TestUser" do
        it "creates a new value object" do
          object = Types::TestUser[:value_object]
          expect(object.inspect).to eql "TestUserValue"
          expect(object.schema.keys).to match_array [:id, :name, :email]
        end
      end

      context "TestPost" do
        it "creates a new value object" do
          object = Types::TestPost[:value_object]
          expect(object.inspect).to eql "TestPostValue"
          expect(object.schema.keys).to match_array [:id, :title, :body]
        end
      end
    end
  end
end
