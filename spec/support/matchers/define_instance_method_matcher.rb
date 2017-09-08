require "rspec/expectations"

RSpec::Matchers.define :define_instance_method do |expected_method|
  match do |instance|
    instance.methods.include?(expected_method)
  end

  failure_message do |instance|
    "#{instance.class.name} was expected to have instance method #{expected_method}"
  end
end
