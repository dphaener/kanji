require "rspec/expectations"

RSpec::Matchers.define :have_argument do |expected_argument|
  match do |klass|
    if @expected_type
      klass.arguments.keys.include?(expected_argument.to_s) &&
        klass.arguments[expected_argument.to_s].type.to_s == @expected_type
    else
      klass.arguments.keys.include?(expected_attribute.to_s)
    end
  end

  chain :of_type do |expected_type|
    @expected_type = expected_type
  end

  failure_message do |klass|
    "#{klass} was expected to have argument #{expected_argument}"
  end
end
