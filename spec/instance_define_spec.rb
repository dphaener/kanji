require "spec_helper"

class TestInstanceDefine
  extend Kanji::InstanceDefine

  instance_define :foo, :bar
end

describe Kanji::InstanceDefine do
  describe "#instance_define" do
    it "defines instance methods" do
      expect(defined? TestInstanceDefine.new.foo).to_not be nil
      expect(defined? TestInstanceDefine.new.bar).to_not be nil
    end

    it "sets instance variables when called" do
      test = TestInstanceDefine.new
      test.foo("baz")
      expect(test.instance_variable_get(:@_foo)).to eql "baz"
    end
  end
end
