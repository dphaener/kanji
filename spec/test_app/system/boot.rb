begin
  require "pry-byebug"
rescue LoadError
end

require_relative "test_app/container"

TestApp::Container.start :rom
TestApp::Container.start :graph
TestApp::Container.start :repos
TestApp::Container.finalize!

require_relative "test_app/application"
