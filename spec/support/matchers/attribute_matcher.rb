require "rspec/expectations"

RSpec::Matchers.define :have_attribute do |expected_attribute|
  match do |klass|
    if @expected_type
      klass.schema.keys.include?(expected_attribute) &&
        klass.schema[expected_attribute] == @expected_type
    else
      klass.schema.keys.include?(expected_attribute)
    end
  end

  chain :of_type do |expected_type|
    @expected_type = expected_type
  end

  failure_message do |klass|
    "#{klass} was expected to have attribute #{expected_attribute}"
  end
end
