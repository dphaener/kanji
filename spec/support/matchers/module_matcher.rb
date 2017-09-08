require "rspec/expectations"

RSpec::Matchers.define :include_module do |action|
  match do |model|
    model.included_modules.include?(action)
  end

  failure_message do |model|
    "#{model} does not include module #{action}"
  end
end

RSpec::Matchers.define :extend_module do |expected_klass|
  match do |klass|
    modules = (class << klass; self end).included_modules
    modules.include?(expected_klass)
  end

  failure_message do |klass|
    "#{klass} does not extend module #{expected_klass}"
  end
end
