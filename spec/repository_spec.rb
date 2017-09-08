require "spec_helper"

describe Kanji::Repository do
  subject do
    config = ROM::Configuration.new(:memory, infer_schema: false)
    config.relation(:test_users) {}
    container = ROM.container(config)
    Repositories::TestUsers.new(container)
  end

  describe "#klass" do
    it "returns the current class" do
      expect(subject.klass).to eq Repositories::TestUsers
    end
  end

  describe "#relation_name" do
    it "returns the stringified name of the relation" do
      expect(subject.relation_name).to eql "test_users"
    end
  end

  describe "#relation" do
    it "returns the relation" do
      expect(subject.relation.name.to_s).to eql "test_users"
    end
  end

  describe "#value_object" do
    it "returns the value object for the repository" do
      expect(subject.value_object.name).to eq Types::TestUser[:value_object].name
    end
  end
end
